# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready () ->

  handleSubmit = (e) ->
    e.preventDefault()
    $.ajax({
        url: "https://api.spotify.com/v1/search",
        data: {
            q: this.query.value,
            type: "artist"
        },
        success: (data) ->
            results = data["artists"]
            html = HandlebarsTemplates["search/index"](results)
            $("#results").html(html)
    })

  $("#artist_search").on "submit", handleSubmit

