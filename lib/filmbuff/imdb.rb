module FilmBuff
  class IMDb
    # locale can be "de_DE", "en_US", "es_ES", "fr_FR", "it_IT" or "pt_PT"
    attr_accessor :locale

    include HTTParty
    include HTTParty::Icebox
    cache :store => 'file', :timeout => 120, :location => Dir.tmpdir

    base_uri 'app.imdb.com'
    default_params = {
      "api" => "v1",
      "app_id" => "iphone1_1",
      "locale" => @locale,
      "timestamp" => Time.now.utc.to_i,
      "sig" => "app1_1"
    }

    def initialize
      @locale = "en_US"
    end

    public
    def find_by_id(imdb_id)
      result = self.class.get('/title/maindetails', :query => {
        tconst: imdb_id
      }).parsed_response
      Title.new(result["data"])
    end

    def find_by_title(title)
      results = self.class.get('/find', :query => { q: title }).parsed_response
      find_by_id(results["data"]["results"][0]["list"][0]["tconst"])
    end
  end
end
