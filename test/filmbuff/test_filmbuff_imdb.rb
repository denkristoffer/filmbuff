require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper'))

describe FilmBuff::IMDb do
  before do
    @imdb = FilmBuff::IMDb.new
  end

  describe '#find_by_id' do
    before do
      @title = @imdb.find_by_id('tt0032138')
    end

    it 'returns a Title' do
      assert_instance_of(FilmBuff::Title, @title)
    end
  end

  describe '#find_by_title' do
    before do
      @title = @imdb.find_by_title('The Wizard of Oz')
    end

    it 'returns an array of titles' do
      assert_instance_of(Array, @title)
    end
  end
end
