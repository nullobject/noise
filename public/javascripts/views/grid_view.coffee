define ["views/cell_view"], (CellView) ->
  class GridView extends Backbone.View
    tagName:   "ul"
    className: "grid"

    constructor: (options) ->
      @readonly = options["readonly"]
      super

    initialize: ->
      @model.bind("add", this._addCell)
      _(@model.models).each(this._addCell)
      this.delegateEvents({}) if @readonly

    render: =>
      $(@el)

    _addCell: (cell) =>
      cellView = new CellView(model: cell, readonly: @readonly)
      cellView.render()
      $(@el).append(cellView.el)
