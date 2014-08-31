class PlaylistsController < SpotifyController
  def show
    @user_id = params[:user_id]
    @playlist_id = params[:id]
  end
end
