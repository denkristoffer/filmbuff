require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe FilmBuff::IMDb do
  before(:all) do
    @imdb = FilmBuff::IMDb.new
  end

  describe "#locale" do
    it "returns the locale" do
      @imdb.locale.should == "en_US"
    end
  end

  describe "#locale=" do
    context "given valid locale" do
      it "sets locale to the given value" do
        @imdb.locale = "de_DE"
        @imdb.locale.should == "de_DE"
      end
    end

    context "given invalid locale" do
      it "raises an exception" do
        lambda { @imdb.locale = "da_DK" }.should raise_error StandardError
      end
    end
  end

  describe "#find_by_id" do
    context "given valid ID" do
      before(:all) do
        @title = @imdb.find_by_id("tt0032138")
      end

      it "returns a Title" do
        @title.instance_of?(FilmBuff::Title).should be_true
      end
    end
  end

  describe "#find_by_title" do
    before(:all) do
      @title = @imdb.find_by_title("The Wizard of Oz")
    end

    it "returns a Title" do
      @title.instance_of?(FilmBuff::Title).should be_true
    end
  end
end
