#= require spec_helper
#= require locations_new

describe "window.Yumster.Locations", ->

  beforeEach ->
    @locations = window.Yumster.Locations.New
    $('body').append('''
      <form id="new_location">
        <input id="location_latitude" name="location[latitude]" type="hidden" />
        <input id="location_longitude" name="location[longitude]" type="hidden" />
        <select id="location_category" name="location[category]">
          <option value="">Select type of location</option>
          <option value="Plant">Plant</option>
          <option value="Dumpster">Dumpster</option>
          <option value="Organization">Organization</option>
        </select>
        <input id="location_description" name="location[description]" size="30" type="text" />
        <input id="location_submit" type="submit" disabled="disabled" />
      </form>
    ''')
    $('#location_submit').attr('disabled','disabled')
    @locations.setup_validator()

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
      $("#location_category").val("Plant")
      $("#location_description").val("description!")
    it "enables the submit button when form contents are valid", ->
      @locations.validate()
      expect($("#location_submit").attr("disabled")).to.be.undefined
    it "disables submit when description is blank", ->
      $("#location_description").val("")
      @locations.validate()
      expect($("#location_submit").attr("disabled")).to.equal "disabled"
    it "disables submit when latitude is blank", ->
      $("#location_latitude").val("")
      @locations.validate()
      expect($("#location_submit").attr("disabled")).to.equal "disabled"
    it "disables submit when longitude is blank", ->
      $("#location_longitude").val("")
      @locations.validate()
      expect($("#location_submit").attr("disabled")).to.equal "disabled"
    it "disables submit when category is blank", ->
      $("#location_category").val(0)
      @locations.validate()
      expect($("#location_submit").attr("disabled")).to.equal "disabled"
