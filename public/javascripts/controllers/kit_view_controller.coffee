define ["controllers/instrument_view_controller", "views/kit_view"], (InstrumentViewController, KitView) ->
  class KitViewController extends Spleen.ViewController
    constructor: (options) ->
      @kit = options["kit"]
      options["title"] = "Kit"

      super(options)

      @kit.bind("change:selected", this._instrumentSelected)

      settingsButton = new Spleen.Button(className: "settings")
      settingsButton.bind("click", -> alert "TODO: kit settings")
      @navigationItem.rightButton = settingsButton

    loadView: ->
      @view = new KitView(model: @kit)

    _instrumentSelected: (instrument) =>
      instrument.set({selected: false}, {silent: true})
      this._openInstrument(instrument)

    _openInstrument: (instrument) ->
      instrumentViewController = new InstrumentViewController(instrument: instrument)
      @navigationController.pushViewController(instrumentViewController)
