window.Yumster or= {}

class Locations
  constructor: ->

  loadAddress: (map, address) ->
    console.log "got one: ",address

$ ->
  window.Yumster.Locations = new Locations
