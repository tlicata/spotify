class UsersController < SpotifyController
  def show
    @user_id = params[:id]
    @body = get_user_profile(@user_id)
    @playlists = get_user_playlists(@user_id)
  end
end
