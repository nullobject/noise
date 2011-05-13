define ["models/note", "models/pattern", "views/cell_view", "views/grid_view"], (Note, Pattern, CellView, GridView) ->
  class GridViewController
    constructor: (@el) ->
      this._initGrid()
      this._renderGrid()

    _initGrid: ->
      @notes     = _([0..15]).map => new Note
      @cellViews = _(@notes).map (note) => new CellView(model: note)
      @pattern   = new Pattern(notes: @notes)
      @gridView  = new GridView(model: @pattern)

    _renderGrid: ->
      @gridView.render()
      $(@el).append(@gridView.el)
      _(@cellViews).each (cellView) =>
        cellView.render()
        $(@gridView.el).append(cellView.el)
