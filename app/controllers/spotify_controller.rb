class SpotifyController < ApplicationController
  BASE_URL = "https://api.spotify.com/v1/"
  CLIENT_ID = ENV['SPOTIFY_CLIENT_ID']
  CLIENT_SECRET = ENV['SPOTIFY_CLIENT_SECRET']

  def make_request(url, params, should_retry = true)
    params ||= {}
    params[:json] = true
    headers = {}
    if access_token
      headers["Authorization"] = "Bearer #{access_token}"
    end
    response = Typhoeus.get(url, headers: headers, params: params)
    body = JSON.parse(response.body)

    if body["error"] and should_retry
      if refresh_token and body["error"]["message"] == "The access token expired"
        request_refresh_token
        body = make_request(url, params, false)
      end
    end

    body
  end

  def get_user_profile(user)
    make_request(BASE_URL + "users/" + user, nil)
  end

  def get_user_playlists(user)
    make_request(playlists_url(user), nil)
  end

  def get_playlist_tracks(user, playlist)
    base = playlists_url(user)
    make_request("#{base}/#{playlist}/tracks", nil)
  end

  def get_user_tracks
    make_request("#{BASE_URL}me/tracks", nil)
  end

  def search_for_album(query)
    search_for(query, "album")
  end

  def search_for_artist(query)
    search_for(query, "artist")
  end

  def search_for_track(query)
    search_for(query, "track")
  end

  private
  def request_refresh_token
    url = "https://accounts.spotify.com/api/token"
    secret = Base64.strict_encode64(CLIENT_ID + ":" + CLIENT_SECRET)
    search = {
      grant_type: 'refresh_token',
      refresh_token: session[:refresh_token]
    }
    headers = {Authorization: "Basic " + secret}
    params = {json: true}
    response = Typhoeus.post(url,
                             body: search,
                             headers: headers,
                             params: params)
    body = JSON.parse(response.body)
    session[:access_token] = body["access_token"]
  end
  def search_for(query, type)
    body = make_request(BASE_URL + "search/", {
                          :q => query,
                          :type => type
                        })
    items = body[type+"s"]["items"]
    names = items.map {|i| i["name"]}
  end
  def playlists_url(user)
    "#{BASE_URL}users/#{user}/playlists"
  end
  def access_token
    session[:access_token]
  end
  def refresh_token
    session[:refresh_token]
  end
end
