# Film Buff - A Ruby wrapper for IMDb's JSON API

[![Build Status](https://travis-ci.org/[sachse]/[filmbuff].png)](https://travis-ci.org/[sachse]/[filmbuff])

## Description

Film Buff provides a Ruby wrapper for IMDb's JSON API, which is the fastest and easiest way to get information from IMDb.

Film Buff supports IMDb's different locales, so information can be retrieved in different languages. See [Locales](#locales).

## Usage

Film Buff 1.0.x provides two ways to return information on a movie or TV show. First, set up an IMDb instance:

    require 'filmbuff'
    imdb = FilmBuff.new

### look_up_id

If you know the movie or TV show's IMDb ID you can return an object with the IMDb information:

    movie = imdb.look_up_id('tt0032138')

    movie.title => "The Wizard of Oz"
    movie.rating => 8.2
    movie.genres => ["Adventure", Family", "Fantasy", "Musical"]

Accessible information for an object returned by `look_up_id` is:

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

### search_for_title

You can also search for a movie or TV show by its title. This will return an array with results from IMDb's search feature:

    results = imdb.search_for_title('The Wizard of Oz')

    results =>  [
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
                        :type=>"title_exact",
                        :imdb_id=>"tt0001463",
                        :title=>"The Wonderful Wizard of Oz",
                        :release_year=>"1910"
                    },

                    etc.

                ]

### Configuration

When initializing a new `FilmBuff` instance keyword arguments can passed to change default behaviours:

- SSL is used by default when communicating with IMDb but it can be turned off by setting `ssl` to false.
- Locale defaults to `en_US` but this behaviour can be changed by passing `locale` with a different value. Locale can also be changed as necessary during runtime. See [Locales](#locales) for more information.
- Caching is possible through [Faraday Http Cache](https://github.com/plataformatec/faraday-http-cache). It can be enabled by setting `cache` to an object such as `Rails.cache` or by passing it a hash that will be used to configure the cache store, such as `:mem_cache_store, 'localhost:11211'`
- Logging can be enabled by setting `logger` to a logging object.

`search_for_title` also takes keyword arguments that can be used to change the default behaviours on a per search basis.

- `limit` limits the amount of results returned.
- `types` decides the types of titles IMDb will search. Valid settings are:
    - title_popular
    - title_exact
    - title_approx
    - title_substring

#### Examples

Return only 2 results:

    results = imdb.search_for_title('The Wizard of Oz', limit: 2)

    results =>  [
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
                    }
                ]


Only return popular results related to the title provided:

    result = imdb.search_for_title('The Wizard of Oz', types: %w(title_popular))

    result =>   [
                    {
                        :type => "title_popular",
                        :imdb_id => "tt0032138",
                        :title => "The Wizard of Oz",
                        :release_year => "1939"
                    }
                ]

#### Locales

To retrieve information in a different language, either pass locale as as keyword argument when setting up an instance of `imdb` or set the instance variable `locale` to your wanted locale once the instance has already been created:

    imdb.locale = 'fr_FR'
    movie = imdb.look_up_id('tt0032138')

    movie.title => "Le magicien d'Oz"
    movie.rating => 8.2
    movie.genres => ["Aventure", "Famille", "Fantasy", "Musical"]

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
