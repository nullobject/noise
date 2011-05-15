define ["views/pattern_view"], (PatternView) ->
  class PatternViewController
    constructor: (@pattern) ->
      @view = new PatternView(model: @pattern)
      this._render()

    _render: ->
      @view.render()
