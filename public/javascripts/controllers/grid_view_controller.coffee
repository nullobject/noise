define ["models/note", "models/pattern", "views/cell_view", "views/grid_view"], (Note, Pattern, CellView, GridView) ->
  class GridViewController
    constructor: (@sampleName) ->
      this._initGrid()
      this._renderGrid()

    # Sets the active cell and re-renders the grid.
    setActiveCell: (index) ->
      lastActiveCell = @activeCell
      @activeCell = @cellViews[index]
      lastActiveCell.render() if lastActiveCell
      @activeCell.render()

    # Returns true if the given cell is active.
    isActiveCell: (cell) ->
      cell == @activeCell

    _initGrid: ->
      @notes     = _([0..15]).map => new Note
      @pattern   = new Pattern(notes: @notes)
      @gridView  = new GridView(model: @pattern, controller: this)
      @cellViews = _(@notes).map (note) => new CellView(model: note, gridView: @gridView)

    _renderGrid: ->
      @gridView.render()
      $("#container").append(@gridView.el)
      _(@cellViews).each (cellView) =>
        cellView.render()
        $(@gridView.el).append(cellView.el)
