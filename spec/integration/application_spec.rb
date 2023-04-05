require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "POST /albums" do
    it 'should return a confirmation' do
      response = post('/albums', title: 'Voyage', release_year: 2022, artist_id: 2)

      repo = AlbumRepository.new
      expect(response.status).to eq(200)
      expect(response.body).to include('<p>You created an album titled: Voyage</p>')
      expect(repo.all.last.title).to eq 'Voyage'
    end

    it 'returns status 400 when given incorrect parameters' do
      response = post('/albums', wrong: 'Voyage', release_year: 2022, artist_id: 2)

      expect(response.status).to eq 400
    end
  end

  context "GET /albums" do
    it "returns a webpage showing all album titles with links to their page" do
      response = get('/albums')
      
      expect(response.body).to include ('<a href="/albums/2">Surfer Rosa</a>')
      expect(response.body).to include ('<a href="/albums/4">Super Trouper</a>')
    end
  end

  context "GET /albums/:id" do
    it 'returns a webpage displaying the album' do
      response = get('/albums/2')

      expect(response.body).to include('<h1>Surfer Rosa</h1>')
      expect(response.body).to include('Release year: 1988')
      expect(response.body).to include('Artist: Pixies')
    end
  end

  context "GET /artists" do
    it 'returns 200 OK and a list of artists with links' do
      response = get('/artists')

      expect(response.body).to include('<a href="/artists/1">Pixies</a>')
      expect(response.body).to include('<a href="/artists/3">Taylor Swift</a>')
    end
  end

  context "GET /artists/:id" do
    it "returns a page with the artists name and genre" do
      response = get('/artists/1')

      expect(response.body).to include('<h1>Pixies</h1>')
      expect(response.body).to include('<p>Genre: Rock</p>')
    end
  end

  context "POST /artists" do
    it 'returns 200 OK and creates an artist' do
      response = post('/artists', name: 'Wild Nothing', genre: 'Indie')
      repo = ArtistRepository.new

      expect(response.status).to eq 200
      expect(repo.all.last.name).to eq 'Wild Nothing'
    end
  end

  context "GET /albums/new" do
    it 'should return the html form to create a new album' do
      response = get('/albums/new')

      expect(response.status).to eq 200
      expect(response.body).to include '<form action="/albums" method="POST">'
      expect(response.body).to include '<input type="number" name="release_year">'
    end
  end
end
