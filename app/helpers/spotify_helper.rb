require "json"
require "typhoeus"

module SpotifyHelper
  BASE_URL = "https://api.spotify.com/v1/"

  def SpotifyHelper.request(url, params, access, refresh)
    params ||= {}
    params[:json] = true
    headers = {}
    if access
      headers["Authorization"] = "Bearer #{access}"
    end
    response = Typhoeus.get(url, headers: headers, params: params)
    body = JSON.parse(response.body)

    if body["error"]
      if refresh and body["error"]["message"] == "The access token expired"
        body = SpotifyHelper.refresh_token(access, refresh)
      end
    end

    body
  end

  def SpotifyHelper.get_user_profile(user)
    SpotifyHelper.request(BASE_URL + "users/" + user, nil, nil, nil)
  end

  def SpotifyHelper.get_user_playlists(user, access, refresh)
    url = "#{BASE_URL}users/#{user}/playlists"
    SpotifyHelper.request(url, nil, access, refresh)
  end

  def SpotifyHelper.search_for(query, type)
    body = SpotifyHelper.request(BASE_URL + "search/", {
                                   :q => query,
                                   :type => type
                                 }, nil, nil)
    items = body[type+"s"]["items"]
    names = items.map {|i| i["name"]}
  end

  def SpotifyHelper.search_for_album(query)
    SpotifyHelper.search_for(query, "album")
  end

  def SpotifyHelper.search_for_artist(query)
    SpotifyHelper.search_for(query, "artist")
  end

  def SpotifyHelper.search_for_track(query)
    SpotifyHelper.search_for(query, "track")
  end
end
