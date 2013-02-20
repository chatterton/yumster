#= require spec_helper
#= require locations

describe "window.Yumster.Locations", ->

  beforeEach ->
    @locations = window.Yumster.Locations

  describe "loadAddress(map, address)", ->
    context "when the address is blank", ->
      it "does nothing", ->
    context "when there's an address", ->
      it "calls out to google to get a position for that address", ->
