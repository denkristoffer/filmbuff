require_relative '../test_helper'

describe FilmBuff::Title do
  before do
    @imdb = FilmBuff::IMDb.new
  end

  describe 'given no locale' do
    before do
      @title = @imdb.find_by_id('tt0032138')
    end

    it 'has an IMDb ID' do
      assert_equal 'tt0032138', @title.imdb_id
    end

    it 'has a title' do
      assert_equal 'The Wizard of Oz', @title.title
    end

    it 'has a tagline' do
      assert_equal 'Mighty Miracle Show Of 1000 Delights !', @title.tagline
    end

    it 'has a plot' do
      assert_equal 'Dorothy Gale is swept away to a magical land in ' <<
        'a tornado and embarks on a quest to see the Wizard who can help her ' <<
        'return home.', @title.plot
    end

    it 'has a runtime' do
      assert_equal 6060, @title.runtime
    end

    it 'has a rating' do
      assert_instance_of Float, @title.rating
    end

    it 'has an amount of votes' do
      assert_instance_of Fixnum, @title.votes
    end

    it 'has a poster URL' do
      assert_match %r{\Ahttp://ia.media-imdb.com/images/.*/}, @title.poster_url
    end

    it 'has genres' do
      assert_equal %w(Adventure Family Fantasy Musical), @title.genres
    end

    it 'has a release date' do
      assert_equal Date.strptime('1939-08-25', '%Y-%m-%d'), @title.release_date
    end
  end

  describe 'given locale' do
    describe '"de_DE"' do
      before do
        @imdb.locale = 'de_DE'
        @title = @imdb.find_by_id('tt0032138')
      end

      it 'returns German information' do
        assert_equal 'Das zauberhafte Land', @title.title
      end
    end

    describe '"en_US"' do
      before do
        @imdb.locale = 'en_US'
        @title = @imdb.find_by_id('tt0032138')
      end

      it 'returns English information' do
        assert_equal 'The Wizard of Oz', @title.title
      end
    end

    describe '"es_ES"' do
      before do
        @imdb.locale = 'es_ES'
        @title = @imdb.find_by_id('tt0032138')
      end

      it 'returns Spanish information' do
        assert_equal 'El mago de Oz', @title.title
      end
    end

    describe '"fr_FR"' do
      before do
        @imdb.locale = 'fr_FR'
        @title = @imdb.find_by_id('tt0032138')
      end

      it 'returns French information' do
        assert_equal 'Le magicien d\'Oz', @title.title
      end
    end

    describe '"it_IT"' do
      before do
        @imdb.locale = 'it_IT'
        @title = @imdb.find_by_id('tt0032138')
      end

      it 'returns Italian information' do
        assert_equal 'Il mago di Oz', @title.title
      end
    end

    describe '"pt_PT"' do
      before do
        @imdb.locale = 'pt_PT'
        @title = @imdb.find_by_id('tt0032138')
      end

      it 'returns Portugese information' do
        assert_equal 'O Feiticeiro de Oz', @title.title
      end
    end
  end
end
