define ["views/grid_view"], (GridView) ->
  class InstrumentView extends Backbone.View
    tagName:   "li"
    className: "instrument"

    initialize: ->
      this._addPattern(@model.get("pattern"))

    render: =>
      $(@el)

    _addPattern: (pattern) =>
      gridView = new GridView(model: pattern)
      gridView.render()
      $(@el).append(gridView.el)
