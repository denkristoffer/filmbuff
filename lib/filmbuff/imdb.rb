module FilmBuff
  class IMDb
    attr_accessor :locale

    include HTTParty
    include HTTParty::Icebox

    base_uri 'https://app.imdb.com'
    format :json

    cache :store => 'memory', :timeout => 120

    def initialize(options = {})
      @locale = options[:locale] || 'en_US'
      self.class.base_uri 'app.imdb.com' if !options[:ssl]
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
