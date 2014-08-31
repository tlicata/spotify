require_relative '../helpers/spotify_helper.rb'

class UsersController < ApplicationController
  def show
    @user_id = params[:id]
    @body = SpotifyHelper.get_user_profile(@user_id)
  end
end
