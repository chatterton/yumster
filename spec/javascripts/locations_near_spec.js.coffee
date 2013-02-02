#= require spec_helper
#= require locations_near
#= require jquery.history.js

describe "window.Yumster.Locations.Near", ->

  beforeEach ->
    @locations = window.Yumster.Locations.Near
    $('body').append('''
      <a href="/whatever" id="nearby_ajax_address" />
      <div id="locations_container"></div>
      <div id="location_container">
        <div class="location well">
          <a class="location_link" /><br>
          Category: <span class="location_category"></span><br>
          <br>
        </div>
      </div>
    ''')

  describe "fillNearbyLocations(lat, long)", ->
    beforeEach ->
      @server = sinon.fakeServer.create()
      @server.respondWith "GET", null, [200, { "Content-Type": "application/json" }, '["whatevah"]']
      sinon.spy(@locations, "fillNearbyLocationsSuccess")
    afterEach ->
      @server.restore()
      @locations.fillNearbyLocationsSuccess.restore()
    context "get locations from server", ->
      beforeEach ->
        @locations.fillNearbyLocations(50, 51)
        @server.respond()
      it "fires an xhr to the server", ->
        @server.requests.length.should.equal 1
      it "builds the address correctly", ->
        @server.requests[0].url.should.equal "/whatever?latitude=50&longitude=51"
      it "calls into the success method with data", ->
        sinon.assert.calledOnce(@locations.fillNearbyLocationsSuccess)
        @locations.fillNearbyLocationsSuccess.calledWith(["whatevah"]).should.be.ok

  describe "fillNearbyLocationsSuccess(data)", ->
    beforeEach ->
      locations = [ "loc1", "loc2" ]
      sinon.stub(@locations, "createLocationHTML")
      @locations.createLocationHTML.withArgs("loc1").returns($("<div>OK1</div>"))
      @locations.createLocationHTML.withArgs("loc2").returns($("<div>OK2</div>"))
      @locations.fillNearbyLocationsSuccess(locations)
    afterEach ->
      @locations.createLocationHTML.restore()
    it "populates #locations_container with locations", ->
      container = $('#locations_container').html()
      container.should.have.string("OK1")
      container.should.have.string("OK2")

  describe "createLocationHTML(location)", ->
    beforeEach ->
      location =
        "category": "Organization"
        "description": "The Church is an Organization"
        "id": 7
        "latitude": 47.6187787290335
        "longitude": -122.302739496959
      @element = @locations.createLocationHTML(location)
    it "populates an element with the name and link", ->
      @element.html().should.have.string("The Church")
      @element.html().should.have.string("/locations/7")

  describe "updateAddressPosition(lat, long)", ->
    beforeEach ->
      sinon.stub window.History, "replaceState"
    afterEach ->
      window.History.replaceState.restore()
    it "updates the address bar with latitude and longitude", ->
      @locations.updateAddressPosition(41.001, 42.002)
      new_address = window.History.replaceState.getCall(0).args[2]
      new_address.should.have.string("41.001")
      new_address.should.have.string("42.002")
    it "shortens long floats to six decimal places", ->
      @locations.updateAddressPosition(41.111111111111, 42.002)
      new_address = window.History.replaceState.getCall(0).args[2]
      new_address.should.have.string("41.111111")
      new_address.should.not.have.string("41.1111111")

  describe "urlParam(name)", ->
    it "returns parameters from query string", ->
      address = "http://whatever?foo=ONE&bar=TWO"
      one = @locations.urlParam("foo", address)
      one.should.equal("ONE")
      two = @locations.urlParam("bar", address)
      two.should.equal("TWO")
