require_relative '../test_helper'

describe FilmBuff::Title do
  before do
    @imdb = FilmBuff.new

    VCR.use_cassette('The Wizard of Oz by ID') do
      @title = @imdb.look_up_id('tt0032138')
    end
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
    assert_equal 6120, @title.runtime
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
