define ["views/pattern_view"], (PatternView) ->
  class InstrumentView extends Backbone.View
    tagName:   "li"
    className: "instrument"

    events:
      "click": "_click"

    initialize: ->
      this._addPattern(@model.get("pattern"))

    _addPattern: (pattern) =>
      patternView = new PatternView(model: pattern, readonly: true)
      patternView.render()
      $(@el).append(patternView.el)

    _click: (event) =>
      # FIXME: the instrument view sould not change the instrument model
      # directly, it should notify the underlying view controller.
      @model.set(selected: true)
