require 'date'

class FilmBuff
  # Represents a single title from IMDb and contains all available data on it
  class Title
    # @return [String] The IMDb ID of Title
    attr_reader :imdb_id

    # @return [String] The title of Title
    attr_reader :title

    # @return [String] The tagline of Title
    attr_reader :tagline

    # @return [String] The plot summary of Title
    attr_reader :plot

    # @return [Integer] The runtime of Title in seconds
    attr_reader :runtime

    # @return [Float] The IMDb rating of Title
    attr_reader :rating

    # @return [Integer] The amount of votes that have been used to determine
    #   the rating of Title
    attr_reader :votes

    # @return [String] The URL for the poster of Title
    attr_reader :poster_url

    # @return [Array<String>] The genres of Title
    attr_reader :genres

    # @return [Date] The release date of Title
    attr_reader :release_date

    # Create a new Title instance from an IMDb hash
    #
    # @param [Hash] imdb_hash
    #   The hash with IMDb information to create a Title instance from
    def initialize(imdb_hash)
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
        begin
          @release_date = Date.strptime(imdb_hash['release_date']['normal'],
                                      '%Y-%m-%d')
        rescue
          @release_date = imdb_hash['release_date']['normal']
        end                              
      end
    end
  end
end
