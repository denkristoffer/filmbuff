require 'filmbuff/title'

require 'http'
require 'json'

# Interacts with IMDb and is used to look up titles
class FilmBuff
  class NotFound < StandardError; end

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
  def initialize(locale = 'en_US', ssl: true)
    @locale = locale
    @protocol = ssl ? 'https' : 'http'
  end

  private

  def build_hash(type, value)
    {
      type: type,
      imdb_id: value['id'],
      title: value['title'],
      release_year: value['description'][/\A\d{4}/]
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
    response = HTTP.get("#{@protocol}://app.imdb.com/title/maindetails", params: {
      tconst: imdb_id, locale: @locale
    })

    if response.status != 200
      fail NotFound
    else
      Title.new(response.parse['data'])
    end
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
  def search_for_title(title, limit: nil, types: %w(title_popular
                                                 title_exact
                                                 title_approx
                                                 title_substring))
    response = JSON.parse(HTTP.get('http://www.imdb.com/xml/find', params: {
      q: title,
      json: '1'
    }).to_s)

    output = []
    results = response.select { |type| types.include? type }

    results.each_key do |type|
      response[type].each do |hash|
        break unless output.size < limit if limit
        next unless hash['id'] && hash['title'] && hash['description']

        output << build_hash(type, hash)
      end
    end

    fail NotFound if output.empty?

    output
  end
end
