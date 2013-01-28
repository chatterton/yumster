#= require spec_helper
#= require locations

describe "window.Yumster.Locations", ->

  beforeEach ->
    @locations = window.Yumster.Locations
    $('body').append('''
      <input id="location_latitude" type="hidden" />
      <input id="location_longitude" type="hidden" />
      <select id="location_category"">
        <option value="">Select type of location</option>
        <option value="Plant">Plant</option>
        <option value="Dumpster">Dumpster</option>
        <option value="Organization">Organization</option>
      </select>
      <input id="location_description" size="30" type="text" />
      <input id="location_submit" type="submit" disabled="disabled" />
    ''')
    $('#location_submit').attr('disabled','disabled')

  describe ('current_location(lat, long)'), ->
    it "updates the form with given latitude and longitude", ->
      @locations.current_location(0.01, 2.03)
      console.log($('body'))
      $('body').find('#location_latitude').val().should.equal '0.01'
      $('body').find('#location_longitude').val().should.equal '2.03'

  describe "validate()", ->
    beforeEach ->
      $("#location_latitude").val(1.0001)
      $("#location_longitude").val(2.0001)
      $("#location_category").val(2)
      $("#location_description").val("description!")
      @locations.validate()
    it "enables the submit button when form contents are valid", ->
      expect($("#location_submit").attr("disabled")).to.be.undefined
