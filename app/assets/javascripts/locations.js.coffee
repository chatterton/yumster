# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.Yumster or= {}

window.Yumster.Locations = class Locations

  @current_location = (lat, long) ->
    console.log "okay! ", lat, long
