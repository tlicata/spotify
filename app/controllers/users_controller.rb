require_relative '../helpers/spotify_helper.rb'

class UsersController < ApplicationController
  def show
    token = session[:access_token]
    @user_id = params[:id]
    @body = SpotifyHelper.get_user_profile(@user_id)
    @playlists = SpotifyHelper.get_user_playlists(@user_id, token)
  end
end
