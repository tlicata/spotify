class ArtistsController < SpotifyController
  def index
  end
  def show
    id = params[:id]
    @artist = get_artist(id)
    @top_tracks = get_artist_top_tracks(id)
    @albums = get_artist_albums(id)
  end
end
