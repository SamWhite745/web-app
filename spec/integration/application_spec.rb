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
    it 'returns 200 OK' do
      response = post('/albums', title: 'Voyage', release_year: 2022, artist_id: 2)

      repo = AlbumRepository.new
      expect(response.status).to eq(200)
      expect(repo.all.last.title).to eq 'Voyage'
    end
  end

  context "GET /albums" do
    it "returns a webpage showing all albums" do
      response = get('/albums')

      expect(response.body).to include ('Title: Doolittle')
      expect(response.body).to include ('Title: Surfer Rosa')
    end
  end

  context "GET /albums/:id" do
    it 'returns a webpage displaying the album' do
      response = get('/albums/2')

      expect(response.body).to include('<h1>Surfer Rosa</h1>')
      expect(response.body).to include('Release year: 1988')
      expect(response.body).to include('Artist: ABBA')
    end
  end

  context "GET /artists" do
    it 'returns 200 OK and a list of artists' do
      response = get('/artists')

      # expect(response.status).to eq 200
      expect(response.body).to eq 'Pixies, ABBA, Taylor Swift, Nina Simone, Kiasmos'
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
end
