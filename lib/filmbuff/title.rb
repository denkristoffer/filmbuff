module FilmBuff
  class Title
    attr_accessor :imdb_id, :title, :tagline, :plot, :runtime, :rating, :votes,
      :poster_url, :genres, :release_date

    def initialize(options = {})
      @imdb_id = options["tconst"]
      @title = options["title"]
      @tagline = options["tagline"]
      @plot = options["plot"]["outline"] if options["plot"]
      @runtime = "#{(options["runtime"]["time"]/60).to_i} min" if
        options["runtime"]
      @rating = options["rating"]
      @votes = options["num_votes"]
      @poster_url = options["image"]["url"] if options["image"]
      @genres = options["genres"] || []
      @release_date = options["release_date"]["normal"] if
        options["release_date"]["normal"]
    end
  end
end
