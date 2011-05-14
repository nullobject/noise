define ["views/pattern_view"], (PatternView) ->
  class PatternViewController
    constructor: (@pattern) ->
      @patternView = new PatternView(model: @pattern)
      @patternView.render()
      $("#container").append(@patternView.el)
