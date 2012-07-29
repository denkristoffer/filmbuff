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



    # @param [Hash] options Options Hash
    # @option options [String] :locale The locale to search with. Will also
    #   return results in the language matching the given locale
    # @option options [Boolean] :ssl Whether or not to use SSL in search
    #   requests
    def initialize(options = {})
      @locale = options[:locale] || 'en_US'
    end

    public

    # Looks up the title with the IMDb ID `imdb_id` and returns a
    # FilmBuff::Title object with information on that title.
    #
    # @param [String] imdb_id The IMDb ID for the title to look up.
    # @return [Title] The FilmBuff::Title object containing information on the
    #   title.
    def find_by_id(imdb_id)
      result = self.class.get('/title/maindetails', :query => {
        :tconst => imdb_id, :locale => @locale
      }).parsed_response

      Title.new(result['data'])
    end

    # Searches IMDb for `title` and returns an array with results.
    #
    # @example Search for 'The Wizard of Oz' but only return 3 results
    #   title = imdb.find_by_title('The Wizard of Oz', limit: 3)
    # @param [String] title The title to search for.
    # @param [Hash] options The options to search with.
    # @option options [Integer] :limit The maximum number of results to return.
    # @option options [Array] :types The types of possible matches to search.
    #   The types will be searched in the provided order.
    # @return [Array<Hash>] An array of hashes, each representing a search
    #   result.
    def find_by_title(title, options = {})
      options = {
        limit: nil,
        types: %w(title_popular title_exact title_approx title_substring)
      }.merge!(options)

      result = self.class.get('http://www.imdb.com/xml/find', :query => {
        :q => title,
        :json => '1',
        :tt => 'on'
      }).parsed_response

      results = []

      options[:types].each do |key|
        if result[key]
          result[key].each do |row|
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
