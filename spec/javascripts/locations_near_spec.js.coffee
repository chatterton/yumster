#= require spec_helper
#= require locations_near

describe "window.Yumster.Locations.Near", ->

  beforeEach ->
    @locations = window.Yumster.Locations.Near
    $('body').append('''
      <a href="/whatever" id="nearby_ajax_address" />
    ''')

  describe "fillNearbyLocations(lat, long)", ->
    beforeEach ->
      @server = sinon.fakeServer.create()
      #@server.respondWith([200, ["locations here"], "OK"])
      @server.respondWith "GET", "/whatever", [200, { "Content-Type": "application/json" }, '["whatevah"]']
      @locations.fillNearbyLocationsSuccess = sinon.spy()
    after ->
      @server.restore()
    context "get locations from server", ->
      beforeEach ->
        @locations.fillNearbyLocations(50, 50)
        @server.respond()
      it "fires an xhr to the server", ->
        @server.requests.length.should.equal 1
      it "uses the correct address", ->
        @server.requests[0].url.should.equal "/whatever"
      it "calls into the success method with data", ->
        sinon.assert.calledOnce(@locations.fillNearbyLocationsSuccess)
        @locations.fillNearbyLocationsSuccess.calledWith(["whatevah"]).should.be.ok
