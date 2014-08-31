class SessionController < ApplicationController
  def index
  end

  CLIENT_ID = ENV['SPOTIFY_CLIENT_ID']
  CLIENT_SECRET = ENV['SPOTIFY_CLIENT_SECRET']
  REDIRECT_URI = ENV['SPOTIFY_REDIRECT_URI']

  def login
    search = {
      :response_type => 'code',
      :client_id => CLIENT_ID,
      :scope => 'user-read-private user-read-email',
      :redirect_uri => REDIRECT_URI,
      :show_dialog => true
    }
    redirect_to "https://accounts.spotify.com/authorize?#{search.to_query}"
  end

  def callback
    search = {
      :code => params[:code],
      :client_id => CLIENT_ID,
      :client_secret => CLIENT_SECRET,
      :grant_type => 'authorization_code',
      :redirect_uri => REDIRECT_URI
    }

    response = Typhoeus.post('https://accounts.spotify.com/api/token',
                             body: search,
                             params: {json: true})

    body = JSON.parse(response.body)

    if body["error"]
      @error = body["error"]
    else
      @access_token = body["access_token"]
      @refresh_token = body["refresh_token"]
      response = Typhoeus.get('https://api.spotify.com/v1/me',
                              headers: {Authorization: "Bearer #{@access_token}"},
                              params: {json: true})

      @user = JSON.parse(response.body)
    end
  end
end
