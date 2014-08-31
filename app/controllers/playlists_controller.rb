class PlaylistsController < SpotifyController
  def show
    @user_id = params[:user_id]
    @playlist_id = params[:id]
    @tracks = get_playlist_tracks(@user_id, @playlist_id)
  end
end
