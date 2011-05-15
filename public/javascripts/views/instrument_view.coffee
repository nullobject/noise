define ["views/pattern_view"], (PatternView) ->
  # FIXME: the instrument view sould not change the instrument model directly,
  # it should notify the underlying view controller.
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
      @model.set(selected: true)
