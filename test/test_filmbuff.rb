require_relative 'test_helper'

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures/vcr_cassettes'
  config.hook_into :webmock
end

describe FilmBuff do
  before do
    @imdb = FilmBuff.new
  end

  describe '#look_up_id' do
    it 'returns a Title' do
      VCR.use_cassette('The Wizard of Oz by ID') do
        @title = @imdb.look_up_id('tt0032138')
      end

      assert_instance_of FilmBuff::Title, @title
    end

    describe 'given a non-existent ID' do
      it 'throws an exception' do
        VCR.use_cassette('non-existent ID') do
          assert_raises(FilmBuff::NotFound) do
            @title = @imdb.look_up_id('tt9999999')
          end
        end
      end
    end

    describe 'given locale' do
      describe 'de_DE' do
        before do
          @imdb.locale = 'de_DE'

          VCR.use_cassette('The Wizard of Oz German') do
            @title = @imdb.look_up_id('tt0032138')
          end
        end

        it 'returns German information' do
          assert_equal 'Der Zauberer von Oz', @title.title
        end
      end

      describe 'en_US' do
        before do
          @imdb.locale = 'en_US'

          VCR.use_cassette('The Wizard of Oz by ID') do
            @title = @imdb.look_up_id('tt0032138')
          end
        end

        it 'returns English information' do
          assert_equal 'The Wizard of Oz', @title.title
        end
      end

      describe 'es_ES' do
        before do
          @imdb.locale = 'es_ES'

          VCR.use_cassette('The Wizard of Oz Spanish') do
            @title = @imdb.look_up_id('tt0032138')
          end
        end

        it 'returns Spanish information' do
          assert_equal 'El mago de Oz', @title.title
        end
      end

      describe 'fr_FR' do
        before do
          @imdb.locale = 'fr_FR'

          VCR.use_cassette('The Wizard of Oz French') do
            @title = @imdb.look_up_id('tt0032138')
          end
        end

        it 'returns French information' do
          assert_equal 'Le magicien d\'Oz', @title.title
        end
      end

      describe 'it_IT' do
        before do
          @imdb.locale = 'it_IT'

          VCR.use_cassette('The Wizard of Oz Italian') do
            @title = @imdb.look_up_id('tt0032138')
          end
        end

        it 'returns Italian information' do
          assert_equal 'Il mago di Oz', @title.title
        end
      end

      describe 'pt_PT' do
        before do
          @imdb.locale = 'pt_PT'

          VCR.use_cassette('The Wizard of Oz Portugese') do
            @title = @imdb.look_up_id('tt0032138')
          end
        end

        it 'returns Portugese information' do
          assert_equal 'O Feiticeiro de Oz', @title.title
        end
      end
    end
  end

  describe '#search_for_title' do
    describe 'with default options' do
      before do
        VCR.use_cassette('The Wizard of Oz by title') do
          @titles = @imdb.search_for_title('The Wizard of Oz')
        end
      end

      it 'returns an array of titles' do
        assert_instance_of Array, @titles
      end

      describe 'given a non-existent title' do
        it 'throws an exception' do
          VCR.use_cassette('non-existent title') do
            assert_raises(FilmBuff::NotFound) do
              @title = @imdb.search_for_title('123456789012345678901234567890')
            end
          end
        end
      end

      # describe 'given a title that redirects' do
      #   it 'follows the redirect and returns a Title object' do
      #     skip 'this still needs a title to test against'

      #     VCR.use_cassette('Redirecting title') do
      #       @title = @imdb.search_for_title('')
      #     end

      #     assert_instance_of FilmBuff::Title, @title
      #   end
      # end
    end

    describe 'given a limit of 3' do
      before do
        VCR.use_cassette('The Wizard of Oz by title') do
          @titles = @imdb.search_for_title('The Wizard of Oz', limit: 3)
        end
      end

      it 'returns 3 results' do
        assert_equal 3, @titles.size
      end
    end

    describe 'when only returning popular titles' do
      before do
        VCR.use_cassette('The Wizard of Oz by title') do
          @title = @imdb.search_for_title('The Wizard of Oz',
                                          types: %w(title_popular))
        end
      end

      it 'returns the 1939 version' do
        assert_equal '1939', @title.first[:release_year]
      end
    end
  end
end
