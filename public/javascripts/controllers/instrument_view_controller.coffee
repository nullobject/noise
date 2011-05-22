define ["views/pattern_view"], (PatternView) ->
  class InstrumentViewController extends Spleen.ViewController
    constructor: (options) ->
      @instrument = options["instrument"]
      options["title"] = @instrument.get("sample")

      super(options)

      settingsButton = new Spleen.Button(className: "settings")
      settingsButton.bind("click", -> alert "TODO: instrument settings")
      @navigationItem.rightButton = settingsButton

    loadView: ->
      @view = new PatternView(model: @instrument.get("pattern"))
