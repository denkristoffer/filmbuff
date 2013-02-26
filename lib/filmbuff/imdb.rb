module FilmBuff
  class IMDb
    # @return [String] The locale currently used by the IMDb instance
    attr_accessor :locale

    # Create a new IMDb instance
    #
    # @param [Hash<Symbol>] options Options Hash
    #   Changes the instance's default behaviours. Options are passed as
    #   symbols in a hash.
    #
    # @option options [String] :locale
    #   The locale to search with. The IMDb instance will also return
    #   results in the language matching the given locale. Defaults to 'en_US'.
    #
    # @option options [Boolean] :ssl
    #   Whether or not to use SSL when searching by IMDb ID (IMDb does not
    #   currently support SSL when searching by title). Defaults to true.
    def initialize(locale: 'en_US', ssl: true)
      @locale = locale
      @protocol = ssl ? 'https' : 'http'
    end

    private

    def connection
      connection ||= Faraday.new(:url => "#@protocol://app.imdb.com") do |c|
        c.response :json
        c.adapter Faraday.default_adapter
      end
    end

    public

    # Looks up the title with the IMDb ID imdb_id and returns a
    # FilmBuff::Title object with information on that title.
    #
    # @param [String] imdb_id
    #   The IMDb ID for the title to look up.
    #
    # @return [Title]
    #   The FilmBuff::Title object containing information on the title.
    #
    # @example Basic usage
    #   movie = imdb_instance.find_by_id('tt0032138')
    def find_by_id(imdb_id)
      response = connection.get '/title/maindetails', {
        :tconst => imdb_id, :locale => @locale
      }

      Title.new(response.body['data'])
    end

    # Searches IMDb for the title provided and returns an array with results
    #
    # @param [String] title The title to search for
    #
    # @param [Hash] options The options to search with
    #
    # @option options [Integer] :limit The maximum number of results to return
    #
    # @option options [Array] :types The types of possible matches to search.
    #   The types will be searched in the provided order
    #
    # @return [Array<Hash>] An array of hashes, each representing a search
    #   result.
    #
    # @example Basic usage
    #   movie = imdb_instance.find_by_title('The Wizard of Oz')
    #
    # @example Only return 3 results
    #   movie = imdb_instance.find_by_title('The Wizard of Oz', limit: 3)
    #
    # @example Only return results containing the exact title provided
    #   movie = imdb_instance.find_by_title('The Wizard of Oz',
    #                                       types: %w(title_exact))
    def find_by_title(title, limit: nil, types: %w(title_popular
                                                   title_exact
                                                   title_approx
                                                   title_substring))
      response = connection.get 'http://www.imdb.com/xml/find', {
        :q => title,
        :json => '1',
        :tt => 'on'
      }

      results = []

      options[:types].each do |key|
        if response.body[key]
          response.body[key].each do |row|
            break unless results.size < options[:limit] if options[:limit]
            next unless row['id'] && row['title'] && row['description']

            title = {
              type: key,
              imdb_id: row['id'],
              title: row['title'],
              release_year: row['description'].scan(/\A\d{4}/).first
            }

            results << title
          end
        end
      end

      results
    end
  end
end
