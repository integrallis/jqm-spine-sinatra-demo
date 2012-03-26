class window.Menu extends Spine.Model
  @configure 'Menu', 'contents'

  @extend @Local

  contentsAsJSON: ->
    JSON.parse @contents