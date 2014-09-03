class SearchController < SpotifyController
  def index
    @access_token = access_token
  end
  def search
    render :text => "d00dz"
  end
end
