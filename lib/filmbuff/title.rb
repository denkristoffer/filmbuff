module FilmBuff
  class Title
    attr_reader :imdb_id, :title, :tagline, :plot, :runtime, :rating, :votes,
      :poster_url, :genres, :release_date

    def initialize(options = {})
      @imdb_id = options["tconst"]
      @title = options["title"]
      @tagline = options["tagline"]
      @plot = options["plot"]["outline"] if options["plot"]
      @runtime = options["runtime"]["time"] if options["runtime"]
      @rating = options["rating"]
      @votes = options["num_votes"]
      @poster_url = options["image"]["url"] if options["image"]
      @genres = options["genres"] || []
      @release_date = Date.strptime(options["release_date"]["normal"], '%Y-%m-%d')
    end
  end
end
