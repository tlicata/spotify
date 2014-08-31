class SpotifyController < ApplicationController
  BASE_URL = "https://api.spotify.com/v1/"

  def make_request(url, params)
    params ||= {}
    params[:json] = true
    headers = {}
    if access_token
      headers["Authorization"] = "Bearer #{access_token}"
    end
    response = Typhoeus.get(url, headers: headers, params: params)
    body = JSON.parse(response.body)

    if body["error"]
      if refresh_token and body["error"]["message"] == "The access token expired"
        request_refresh_token
      end
    end

    body
  end

  def get_user_profile(user)
    make_request(BASE_URL + "users/" + user, nil)
  end

  def get_user_playlists(user)
    make_request("#{BASE_URL}users/#{user}/playlists", nil)
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
    # needs implementation
  end
  def search_for(query, type)
    body = make_request(BASE_URL + "search/", {
                          :q => query,
                          :type => type
                        })
    items = body[type+"s"]["items"]
    names = items.map {|i| i["name"]}
  end
  def access_token
    session[:access_token]
  end
  def refresh_token
    session[:refresh_token]
  end
end
