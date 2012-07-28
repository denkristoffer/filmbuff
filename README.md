# Film Buff - A Ruby wrapper for IMDb's JSON API

## Description

Film Buff provides a Ruby wrapper for IMDb's JSON API, which is the fastest and easiest way to get information from IMDb.

Film Buff supports IMDb's different locales, so information can be retrieved in different languages. See [Locales](#locales).

## Usage

Film Buff 0.2.x provides two ways to return information on a movie or TV show. First, set up an IMDb instance:

    require 'filmbuff'
    imdb = FilmBuff::IMDb.new

### find_by_id

If you know the movie or TV show's IMDb ID you can return an object with the IMDb information:

    movie = imdb.find_by_id('tt0032138')

    movie.title => "The Wizard of Oz"
    movie.rating => 8.3
    movie.genres => ["Adventure", Family", "Fantasy", "Musical"]

Accessible information for an object returned by `find_by_id` is:

- Title
- Tagline
- Plot
- Runtime
- Rating
- Amount of votes
- Poster URL
- Genres
- Release date
- IMDb ID

### find_by_title

You can also search for a movie or TV show by its title. This will return an array with results from IMDb's search feature:

    results = imdb.find_by_title('The Wizard of Oz')

    results => [
                    {
                        :type => "title_popular",
                        :imdb_id => "tt0032138",
                        :title => "The Wizard of Oz",
                        :release_year => "1939"
                    },

                    {
                        :type => "title_exact",
                        :imdb_id => "tt0016544",
                        :title => "The Wizard of Oz",
                        :release_year => "1925"
                    },

                    {
                        :type => "title_exact",
                        :imdb_id => "tt0001463",
                        :title => "The Wonderful Wizard of Oz",
                        :release_year => "1910"
                    },

                    etc.
               ]

`find_by_title` takes an option hash where you can set the following options

- limit
- types

`limit` limits the amount of results returned.

`types` decides the types of titles IMDb will search. Valid settings are:

- title_popular
- title_exact
- title_approx
- title_substring

These can be passed in an array inside the hash.

    results = imdb.find_by_title('The Wizard of Oz', types: %w(title_popular))

    results => [
                    {
                        :type => "title_popular",
                        :imdb_id => "tt0032138",
                        :title => "The Wizard of Oz",
                        :release_year => "1939"
                    }
                ]

### Configuration

#### Locales

To retrieve information in a different language, either pass locale in the options hash when setting up an instance of `imdb` or set the instance variable locale to your wanted locale once the instance has already been created:

    imdb.locale = 'de_DE'
    movie = imdb.find_by_id('tt0032138')

    movie.title => "Das zauberhafte Land"
    movie.rating => 8.3
    movie.genres => ["Abenteuer", "Familie", "Fantasy", "Musical"]

Supported locales are

- de_DE (German)
- en_US (English) (Default)
- es_ES (Spanish)
- fr_FR (French)
- it_IT (Italian)
- pt_PT (Portuguese)

## Links

- [Public git repository](https://github.com/sachse/filmbuff)
- [Online documentation](http://rubydoc.info/gems/filmbuff/frames)
- [Issue tracker](https://github.com/sachse/filmbuff/issues)
- [Film Buff on RubyGems](http://rubygems.org/gems/filmbuff)

## Authors

- [Kristoffer Sachse](https://github.com/sachse)

## Contribute

You can contribute either with code by forking the project, implementing your changes in its own branch, and sending a pull request, or you can report issues and ideas for changes [on the issues page](https://github.com/sachse/filmbuff/issues).

### Contributors
- [Jon Maddox](https://github.com/maddox) inspired the 0.1.0 rewrite through his imdb_party gem.
