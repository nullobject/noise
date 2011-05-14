define ["views/grid_view"], (GridView) ->
  class GridViewController
    constructor: (@pattern) ->
      @gridView = new GridView(model: @pattern)
      @gridView.render()
      $("#container").append(@gridView.el)
