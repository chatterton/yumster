#= require spec_helper
#= require locations_new

describe "window.Yumster.Locations.New", ->

  beforeEach ->
    @locations = window.Yumster.Locations.New
    $('body').append('''
      <div id="error_explanation">
      </div>
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
      <span id="character_count"><span id="character_count_current"></span> / 45</span>
    ''')
    $('#location_submit').attr('disabled','disabled')

  describe 'current_location(lat, long)', ->
    it "updates the form with given latitude and longitude", ->
      @locations.current_location(0.01, 2.03)
      $('body').find('#location_latitude').val().should.equal '0.01'
      $('body').find('#location_longitude').val().should.equal '2.03'

  describe 'errorHandler(error, element)', ->
    beforeEach ->
      @error1 = $('<input for="location_description">text1</input>')
      @error2 = $('<input for="location[category]">text2</input>')
    context 'when there is no error box visible', ->
      it 'adds the error to the screen', ->
        @locations.errorHandler(@error1, {})
        html = $('#error_explanation').html()
        html.should.have.string "text1"
    context 'when there is already an error box', ->
      beforeEach ->
        @locations.errorHandler(@error1, {})
      it 'appends the error to the error box', ->
        @locations.errorHandler(@error2, {})
        $('#alert_list li').length.should.equal 2

  describe 'updateCharacterCount()', ->
    context 'when there are between 0 and 4 characters', ->
      beforeEach ->
        $('#location_description').val "four"
        @locations.updateCharacterCount()
      it 'should update the number correctly', ->
        $('#character_count_current').text().should.equal "4"
      it 'should be red', ->
        $('#character_count').hasClass('character_count_red').should.be.ok
        $('#character_count').hasClass('character_count_green').should.not.be.ok
    context 'when there are between 5 and 45 characters', ->
      beforeEach ->
        $('#location_description').val "this is a string of 45 characters............"
        @locations.updateCharacterCount()
      it 'should update the number correctly', ->
        $('#character_count_current').text().should.equal "45"
      it 'should be green', ->
        $('#character_count').hasClass('character_count_red').should.not.be.ok
        $('#character_count').hasClass('character_count_green').should.be.ok
    context 'when there are more than 45 characters', ->
      beforeEach ->
        $('#location_description').val "this is a string of 46 characters............."
        @locations.updateCharacterCount()
      it 'should update the number correctly', ->
        $('#character_count_current').text().should.equal "46"
      it 'should be red', ->
        $('#character_count').hasClass('character_count_red').should.be.ok
        $('#character_count').hasClass('character_count_green').should.not.be.ok

