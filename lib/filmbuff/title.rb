module FilmBuff
  # Contains all accessible information on an IMDb title
  class Title
    # @return [String] Returns the IMDb ID of `Title`
    attr_reader :imdb_id

    # @return [String] Returns the title of `Title`
    attr_reader :title

    # @return [String] Returns the tagline of `Title`
    attr_reader :tagline

    # @return [String] Returns the plot summary of `Title`
    attr_reader :plot

    # @return [Integer] Returns the runtime of `Title` in seconds
    attr_reader :runtime

    # @return [Float] Returns the IMDb rating of `Title`
    attr_reader :rating

    # @return [Integer] Returns the amount of votes that have been used to
    #   determine the rating of `Title`
    attr_reader :votes

    # @return [String] Returns a URL for the poster of `Title`
    attr_reader :poster_url

    # @return [Array<String>] Returns the genres of `Title`
    attr_reader :genres

    # @return [Date] Returns the release date of `Title`
    attr_reader :release_date

    def initialize(imdb_hash = {})
      @imdb_id = imdb_hash['tconst']
      @title = imdb_hash['title']
      @tagline = imdb_hash['tagline'] if imdb_hash['tagline']
      @plot = imdb_hash['plot']['outline'] if imdb_hash['plot']
      @runtime = imdb_hash['runtime']['time'] if imdb_hash['runtime']
      @rating = imdb_hash['rating']
      @votes = imdb_hash['num_votes']
      @poster_url = imdb_hash['image']['url'] if imdb_hash['image']
      @genres = imdb_hash['genres'] || []

      if imdb_hash['release_date']
        @release_date = Date.strptime(imdb_hash['release_date']['normal'],
                                      '%Y-%m-%d')
      end
    end
  end
end
