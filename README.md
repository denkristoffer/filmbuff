# Film Buff - A Ruby wrapper for IMDb's JSON API

## Description

Film Buff provides a Ruby wrapper for IMDb's JSON API, which is the fastest and easiest way to get information from IMDb.

Film Buff supports IMDb's different locales, so information can be retrieved in different languages. See [Locales](#Locales).

## Installation

### RubyGems

You can install the latest Film Buff gem using RubyGems

    gem install filmbuff

### GitHub

Alternatively you can check out the latest code directly from Github

    git clone http://github.com/sachse/filmbuff.git

## Usage

Accessible information for a title retrieved from IMDb is:

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

### Examples

Film Buff 0.1.x provides two easy ways to return an object with information on a movie or TV show. First, set up an IMDb instance:

    require 'filmbuff'
    imdb = FilmBuff::IMDb.new

You can then find a movie by its title. This will return the first result from IMDb's search feature:

    movie = imdb.find_by_title("The Wizard of Oz")
    
    movie.title => "The Wizard of Oz"
    movie.rating => 8.3
    movie.genres => ["Adventure", "Comedy", "Family", "Fantasy", "Musical"]

If you know the movie's IMDb ID you can get the information as well:

    movie = imdb.find_by_id("tt0032138")
    
    movie.title => "The Wizard of Oz"
    movie.rating => 8.3
    movie.genres => ["Adventure", "Comedy", "Family", "Fantasy", "Musical"]

#### Locales

To retrieve information in a different language, set the instance variable locale to your wanted locale:

    imdb.locale = "de_DE"
    movie = imdb.find_by_id("tt0032138")
    
    movie.title => "Das zauberhafte Land"
    movie.rating => 8.3
    movie.genres => ["Abenteuer", "Komödie", "Familie", "Fantasy", "Musical"]

Supported locales are

- de_DE (German)
- en_US (English) (Default)
- es_ES (Spanish)
- fr_FR (French)
- it_IT (Italian)
- pt_PT (Portuguese)

## Authors

* [Kristoffer Sachse](https://github.com/sachse)

## Contribute

Fork the project, implement your changes in its own branch, and send
a pull request to me. I'll gladly consider any help or ideas.

### Contributors
- [Jon Maddox](https://github.com/maddox) inspired the 0.1.0 rewrite through his imdb_party gem.
