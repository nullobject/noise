define ["views/pattern_view"], (PatternView) ->
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
      patternView = new PatternView(model: pattern, readonly: true)
      patternView.render()
      $(@el).append(patternView.el)

    _mouseDown: (event) =>
      # TODO: display grid view.
