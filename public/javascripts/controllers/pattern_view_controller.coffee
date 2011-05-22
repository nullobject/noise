define ["views/pattern_view"], (PatternView) ->
  class PatternViewController extends Spleen.ViewController
    constructor: (options) ->
      @pattern = options["pattern"]

      super(options)

      settingsButton = new Spleen.Button(className: "settings")
      settingsButton.bind("click", -> alert "TODO: pattern settings")
      @navigationItem.rightButton = settingsButton

    loadView: ->
      @view = new PatternView(model: @pattern)
