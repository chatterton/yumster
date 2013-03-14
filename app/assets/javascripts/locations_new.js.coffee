#= require jquery.validate.min

window.Yumster or= {}
window.Yumster.Locations or= {}

LocationsNew = class LocationsNew

  constructor: ->
    @setup_validator()
    @setup_onchange()
    @updateCharacterCount()

  setup_onchange: ->
    $('#location_description').keyup ->
      console.log "wut"
      window.Yumster.Locations.New.updateCharacterCount()

  setup_validator: ->
    $('#new_location').validate
      rules:
        "location[latitude]": { required: true }
        "location[longitude]": { required: true }
        "location[category]": { required: true }
        "location[description]":
          required: true
          minlength: 5
          maxlength: 45
      ignore: "" # validator defaults to ignoring hidden
      errorPlacement: @errorHandler
      onsubmit: true
      onfocusout: false
      onkeyup: false
      onclick: false
      invalidHandler: (form, validator) ->
        $('#error_explanation').empty()

  current_location: (lat, long) ->
    $('input#location_latitude').val(lat)
    $('input#location_longitude').val(long)

  errorHandler: (error, element) ->
    problem = error.attr('for')
    text = switch problem
      when 'location[category]' then 'Please select the type of location you\'re adding'
      when 'location_description' then "There is a problem with the site description: #{error.text()}"
      else 'Our apologies, we encountered a technical problem creating this location. Please try again later.'
    unless alert_box = $('#alert_box')[0]
      alert_box = $('<div class="alert alert-error" id="alert_box"></div>')
      $('#error_explanation').append(alert_box)
    unless alert_list = $('#alert_list')[0]
      alert_list = $('<ul id="alert_list"></ul>')
      alert_box.append(alert_list)
    alert = $("<li>#{text}</li>")
    $(alert_list).append(alert)
    $('html, body').animate({scrollTop:0}, 'slow');

  updateCharacterCount: () ->
    characters = if $('#location_description').val() then $('#location_description').val().length else 0
    $('#character_count_current').text(characters)
    if characters >= 5 and characters <= 45
      $('#character_count').toggleClass('character_count_red', false)
      $('#character_count').toggleClass('character_count_green', true)
    else
      $('#character_count').toggleClass('character_count_red', true)
      $('#character_count').toggleClass('character_count_green', false)

  geolocationCallback: (result) ->
    loc = result.geometry.location
    window.Yumster.Locations.New.map.setCenter(loc)

$ ->
  window.Yumster.Locations.New = new LocationsNew
