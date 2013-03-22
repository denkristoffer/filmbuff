require 'filmbuff/title'

require 'faraday'
require 'faraday_middleware'
require 'faraday-http-cache'

# Interacts with IMDb and is used to look up titles
class FilmBuff
  # @return [String] The locale currently used by the IMDb instance
  attr_accessor :locale

  # Create a new FilmBuff instance
  #
  # @param [String] locale
  #   The locale to search with. The FilmBuff instance will also return
  #   results in the language matching the given locale. Defaults to `en_US`
  #
  # @param [Boolean] ssl
  #   Whether or not to use SSL when searching by IMDb ID (IMDb does not
  #   currently support SSL when searching by title). Defaults to `true`
  #
  # @param [Object, Hash, nil] cache
  #   Whatever Faraday-http-cache should use for caching. Can be both an
  #    object such as `Rails.cache`, a hash like
  #   `:mem_cache_store, 'localhost:11211'`, or `nil`, meaning no caching.
  #   Defaults to `nil`
  #
  # @param [Object] logger
  #   An instance of a logger object. Defaults to `nil` and no logging
  def initialize(options = {})
    @locale   = options[:locale] || 'en_US'
    @protocol = options[:ssl] == false ? 'http' : 'https'
    @cache    = options[:cache]
    @logger   = options[:logger]
  end

  private

  def connection
    @connection ||= Faraday.new(:url => "#{@protocol}://app.imdb.com") do |c|
      c.use :http_cache, @cache, :logger => @logger
      c.response :json
      c.adapter Faraday.default_adapter
    end
  end

  def build_hash(type, values)
    {
      :type => type,
      :imdb_id => values['id'],
      :title => values['title'],
      :release_year => values['description'][/\A\d{4}/]
    }
  end

  public

  # Looks up the title with the IMDb ID imdb_id and returns a
  # FilmBuff::Title object with information on that title
  #
  # @param [String] imdb_id
  #   The IMDb ID for the title to look up
  #
  # @return [Title]
  #   The FilmBuff::Title object containing information on the title
  #
  # @example Basic usage
  #   movie = imdb_instance.look_up_id('tt0032138')
  def look_up_id(imdb_id)
    response = connection.get '/title/maindetails', {
      :tconst => imdb_id, :locale => @locale
    }

    Title.new(response.body['data'])
  end

  # Searches IMDb for the title provided and returns an array with results
  #
  # @param [String] title The title to search for
  #
  # @param [Integer] limit The maximum number of results to return
  #
  # @param [Array] types The types of matches to search for.
  #   These types will be searched in the provided order. Can be
  #   `title_popular`, `title_exact`, `title_approx`, and `title_substring`
  #
  # @return [Array<Hash>] An array of hashes, each representing a search result
  #
  # @example Basic usage
  #   movie = imdb_instance.search_for_title('The Wizard of Oz')
  #
  # @example Return only 2 results
  #   movie = imdb_instance.search_for_title('The Wizard of Oz', limit: 2)
  #
  # @example Only return results containing the exact title provided
  #   movie = imdb_instance.search_for_title('The Wizard of Oz',
  #                                          types: %w(title_exact))
  def search_for_title(title, options = {})
    response = connection.get 'http://www.imdb.com/xml/find', {
      :q => title,
      :json => '1',
      :tt => 'on'
    }

    limit = options[:limit]
    types = options[:types] || %w(title_popular title_exact title_approx 
      title_substring)

    output = []
    results = response.body.select { |key| types.include? key }

    results.each_key do |key|
      response.body[key].each do |row|
        break unless output.size < limit if limit
        next unless row['id'] && row['title'] && row['description']

        output << build_hash(key, row)
      end
    end

    output
  end
end
