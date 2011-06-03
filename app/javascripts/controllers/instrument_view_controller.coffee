define ["controllers/instrument_settings_view_controller", "views/pattern_view"], (InstrumentSettingsViewController, PatternView) ->
  class InstrumentViewController extends Spleen.ViewController
    constructor: (options) ->
      @instrument = options["instrument"]
      @instrument.bind("change:sound", this._setTitle)
      super(options)
      this._setTitle()

      settingsButton = new Spleen.Button(className: "settings")
      settingsButton.bind("click", this._openInstrumentSettings)
      @navigationItem.rightButton = settingsButton

    loadView: ->
      @view = new PatternView(model: @instrument.get("pattern"))

    _openInstrumentSettings: =>
      instrumentSettingsViewController = new InstrumentSettingsViewController(instrument: @instrument)
      @navigationController.pushViewController(instrumentSettingsViewController)

    _setTitle: =>
      this.setTitle(@instrument.get("sound").toString())
