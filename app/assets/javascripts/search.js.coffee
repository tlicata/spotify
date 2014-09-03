# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.onload = () ->

  handleSubmit = (e) ->
    e.preventDefault()
    console.log "access_token: " + access_token
    $.ajax({
        url: "https://api.spotify.com/v1/search",
        data: {
            q: this.query.value,
            type: this.type.value
        },
        success: (data) ->
            console.log "data: ", data
    })

  $("#search").on "submit", handleSubmit
