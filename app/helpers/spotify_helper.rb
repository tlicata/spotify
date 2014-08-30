require "json"
require "typhoeus"

module SpotifyHelper
  BASE_URL = "https://api.spotify.com/v1/"

  def SpotifyHelper.search_for_album(query)
    results = Typhoeus.get(BASE_URL + "search/",
                           :params => {
                             :q => query,
                             :type => "album"
                           })

    body = JSON.parse(results.body)
    albums = body["albums"]["items"]
    names = albums.map {|i| i["name"]}
  end

  def SpotifyHelper.search_for_artist(query)
    results = Typhoeus.get(BASE_URL + "search/",
                           :params => {
                             :q => query,
                             :type => "artist"
                           })
    body = JSON.parse(results.body)
    artists = body["artists"]["items"]
    names = artists.map {|i| i["name"]}
  end
end
