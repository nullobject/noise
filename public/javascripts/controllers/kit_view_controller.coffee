define ["controllers/pattern_view_controller", "views/kit_view"], (PatternViewController, KitView) ->
  class KitViewController extends Spleen.ViewController
    constructor: (options) ->
      @kit = options["kit"]
      @kit.bind("change:selected", this._instrumentSelected)

      super(options)

      settingsButton = new Spleen.Button(className: "settings")
      settingsButton.bind("click", -> alert "TODO: kit settings")
      @navigationItem.rightButton = settingsButton

    loadView: ->
      @view = new KitView(model: @kit)

    _instrumentSelected: (instrument) =>
      instrument.set({selected: false}, {silent: true})
      this._openInstrument(instrument)

    _openInstrument: (instrument) ->
      patternViewController = new PatternViewController(title: instrument.get("sample"), pattern: instrument.get("pattern"))
      this.navigationController.pushViewController(patternViewController)
