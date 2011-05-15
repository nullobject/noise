define ["controllers/view_controller", "views/pattern_view"], (ViewController, PatternView) ->
  class PatternViewController extends ViewController
    constructor: (options) ->
      @pattern = options["pattern"]
      super(options)

    loadView: ->
      @view = new PatternView(model: @pattern)
