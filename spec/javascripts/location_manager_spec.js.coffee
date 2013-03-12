#= require spec_helper
#= require location_manager

describe "window.Yumster.LocationManager", ->
  beforeEach ->
    @manager = new window.Yumster._LocationManager
    window.Yumster.LocationManager = @manager
    l1 =
      latitude: 42.001
      longitude: 42.002
    l2 =
      latitude: 42.003
      longitude: 42.004
    l3 =
      latitude: 41
      longitude: 41
    l4 =
      latitude: 42.1
      longitude: 42.1
    @locations = [l1, l2, l3, l4]

  describe "addLocations(locationArray, lat, lng, span)", ->
    beforeEach ->
      @manager.addLocations(@locations, 42, 42, .025)
    it "saves its arguments", ->
      @manager.locations.should.equal @locations

  describe "clear()", ->
    beforeEach ->
      @manager.locations = ["fuh"]
      @manager.clear()
    it "clears its locations", ->
      @manager.locations.should.have.length 0

  describe "canShow(checkLat, checkLng, checkSpan)", ->
    beforeEach ->
      @manager.addLocations(@locations, 42, 42, .025)
    context "when all parameters are within the current area", ->
      it "returns true", ->
        val = @manager.canShow(42.0001, 42.0002, .01)
        val.should.be.true
    context "when the span is outside the current area", ->
      it "returns false", ->
        val = @manager.canShow(42.01, 42.02, .5)
        val.should.be.false
    context "when the center point is outside the current area", ->
      it "returns false", ->
        val = @manager.canShow(41, 41, .01)
        val.should.be.false
    context "after clearing the manager", ->
      it "returns false", ->
        @manager.clear()
        val = @manager.canShow(42.0001, 42.0002, .01)
        val.should.be.false

  describe "getClusterLocations(lat, lng, span)", ->
    beforeEach ->
      @manager.addLocations(@locations, 41, 41, 3)
      @clusters = @manager.getClusterLocations(42, 42, .2)
    it "returns a cluster location of the two nearby locations", ->
      @clusters.length.should.equal 1
    describe "the cluster", ->
      beforeEach ->
        @cluster = @clusters[0]
      it "should be in the right place", ->
        @cluster.latitude.should.be.within(41.9, 42.1)
        @cluster.longitude.should.be.within(41.9, 42.1)
      it "should contain the clustered locations", ->
        @cluster.should.have.property('locations').with.length 2
        @cluster.locations.should.contain @locations[0]
        @cluster.locations.should.contain @locations[1]
        @cluster.locations.should.not.contain @locations[2]
        @cluster.locations.should.not.contain @locations[3]

  describe "getMarkerLocations(lat, lng, span)", ->
    beforeEach ->
      @manager.addLocations(@locations, 41, 41, 3)
      @markers = @manager.getMarkerLocations(42, 42, .2)
    it "returns a list of those markers not in a cluster", ->
      @markers.length.should.equal 1
      @markers.should.not.contain @locations[0]
      @markers.should.not.contain @locations[1]
      @markers.should.not.contain @locations[2]
      @markers.should.contain @locations[3]

