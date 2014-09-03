# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.onload = () ->

  handleSubmit = (e) ->
    e.preventDefault()
    console.log "access_token: " + access_token
    search_type = this.type.value
    $.ajax({
        url: "https://api.spotify.com/v1/search",
        data: {
            q: this.query.value,
            type: search_type
        },
        success: (data) ->
            results = data[search_type+"s"]
            html = HandlebarsTemplates["search/index"](results)
            $("#results").html(html)
    })

  $("#search").on "submit", handleSubmit

