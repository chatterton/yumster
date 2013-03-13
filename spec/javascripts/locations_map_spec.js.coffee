#= require spec_helper
#= require locations_map

describe "window.Yumster.Locations.Map", ->
  beforeEach ->
    @lm = new window.Yumster.Locations._Map
    window.Yumster.Locations.Map = @lm

  describe "setting the map", ->
    it "saves the map to a window global", ->
      @lm.setMap("foo")
      window.Yumster.Locations.Map.map.should.equal "foo"
