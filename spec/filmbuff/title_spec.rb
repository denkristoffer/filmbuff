require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe FilmBuff::Title do
  before(:all) do
    @imdb = FilmBuff::IMDb.new
    @title = @imdb.find_by_id("tt0032138")
  end

  it "has an IMDb ID" do
    @title.imdb_id.should == "tt0032138"
  end

  it "has a title" do
    @title.title.should == "The Wizard of Oz"
  end

  it "has a tagline" do
    @title.tagline.should == "\"The Wizard\" Musical Returns By " <<
    "Unprecedented Demand! [UK re-release]"
  end

  it "has a plot" do
    @title.plot.should == "Dorothy Gale is swept away to a magical land in " <<
    "a tornado and embarks on a quest to see the Wizard who can help her " <<
    "return home."
  end

  it "has a runtime" do
    @title.runtime.should == "101 min"
  end

  it "has a rating" do
    @title.rating.should be_a(Float)
  end

  it "has an amount of votes" do
    @title.votes.should be_a(Integer)
  end

  it "has a poster URL" do
    @title.poster_url.should match /http:\/\/ia.media-imdb.com\/images\/.*/
  end

  it "has genres" do
    @title.genres.should == %w[ Adventure Comedy Family Fantasy Musical]
  end

  it "has a release date" do
    @title.release_date.should == DateTime.parse("1939-08-25")
  end
end
