require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe FilmBuff::IMDb do
  context 'given no options' do
    before :all do
      @imdb = FilmBuff::IMDb.new
    end

    describe '#find_by_id' do
      before :all do
        @title = @imdb.find_by_id('tt0032138')
      end

      it 'returns a Title' do
        @title.instance_of?(FilmBuff::Title).should be_true
      end
    end

    describe '#find_by_title' do
        before :all do
          @title = @imdb.find_by_title('The Wizard of Oz')
        end

        it 'returns a Title' do
          @title.instance_of?(FilmBuff::Title).should be_true
      end
    end
  end
end
