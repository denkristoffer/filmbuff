module FilmBuff
  class IMDb
    attr_accessor :locale

    include HTTParty
    include HTTParty::Icebox
    cache :store => 'memory', :timeout => 120

    base_uri 'app.imdb.com'

    def initialize
      @locale = "en_US"
    end

    public
    def find_by_id(imdb_id)
      result = self.class.get('/title/maindetails', :query => {
        :tconst => imdb_id, :locale => @locale
      }).parsed_response
      
      Title.new(result['data'])
    end

    def find_by_title(title)
      results = self.class.get('/find', :query => {
        :q => title, :locale => @locale
      }).parsed_response
      
      find_by_id(results['title_popular'][0]['id'])
    end
  end
end
