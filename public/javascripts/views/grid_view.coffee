define ["views/cell_view"], (CellView) ->
  class GridView extends Backbone.View
    tagName:   "ul"
    className: "grid"

    initialize: ->
      @model.bind("add", this._addCell)
      _(@model.models).each(this._addCell)

    render: =>
      $(@el)

    _addCell: (cell) =>
      cellView = new CellView(model: cell)
      cellView.render()
      $(@el).append(cellView.el)
