define ["views/pattern_view"], (PatternView) ->
  class PatternViewController extends Spleen.ViewController
    constructor: (options) ->
      @pattern = options["pattern"]
      super(options)

    loadView: ->
      @view = new PatternView(model: @pattern)
