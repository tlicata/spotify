require_relative '../helpers/spotify_helper.rb'

class UsersController < ApplicationController
  def show
    access = session[:access_token]
    refresh = session[:refresh_token]
    @user_id = params[:id]
    @body = SpotifyHelper.get_user_profile(@user_id)
    @playlists = SpotifyHelper.get_user_playlists(@user_id, access, refresh)
  end
end
