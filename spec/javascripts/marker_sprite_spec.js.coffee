#= require spec_helper
#= require marker_sprite

describe "window.Yumster.MarkerSprite", ->
  beforeEach ->
    @MarkerSprite = window.Yumster._MarkerSprite
    @markersprite = new @MarkerSprite
    window.Yumster.MarkerSprite = @markersprite

  describe "spriteOffsetsForOrdinal(ordinal)", ->
    it "returns 0, 0 for 0", ->
      [xoffset, yoffset] = @markersprite.spriteOffsetsForOrdinal(0)
      xoffset.should.equal 0
      yoffset.should.equal 0
    it "correctly wraps around to the next column", ->
      [xoffset, yoffset] = @markersprite.spriteOffsetsForOrdinal(@MarkerSprite.SPRITE_XCOUNT)
      xoffset.should.equal @MarkerSprite.SPRITE_XSIZE
      yoffset.should.equal 0
