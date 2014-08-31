require "json"
require "typhoeus"

module SpotifyHelper
  BASE_URL = "https://api.spotify.com/v1/"


  def SpotifyHelper.get_user_profile(user)
    response = Typhoeus.get(BASE_URL + "users/" + user,
                            params: {json: true})
    JSON.parse(response.body)
  end

  def SpotifyHelper.get_user_playlists(user, token)
    url = "#{BASE_URL}users/#{user}/playlists"
    headers = {}
    if token
      headers["Authorization"] = "Bearer #{token}"
    end
    response = Typhoeus.get(url,
                            headers: headers,
                            params: {json: true})
    JSON.parse(response.body)
  end

  def SpotifyHelper.search_for(query, type)
    results = Typhoeus.get(BASE_URL + "search/",
                           :params => {
                             :q => query,
                             :type => type
                           })
    body = JSON.parse(results.body)
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
