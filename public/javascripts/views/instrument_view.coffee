define ["views/grid_view"], (GridView) ->
  class InstrumentView extends Backbone.View
    tagName:   "li"
    className: "instrument"

    events:
      "mousedown": "_mouseDown"

    initialize: ->
      this._addPattern(@model.get("pattern"))

    render: =>
      $(@el)

    _addPattern: (pattern) =>
      gridView = new GridView(model: pattern, readonly: true)
      gridView.render()
      $(@el).append(gridView.el)

    _mouseDown: (event) =>
      # TODO: display grid view.
