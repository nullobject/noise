define ["views/instrument_settings_view"], (InstrumentSettingsView) ->
  class InstrumentSettingsViewController extends Spleen.ViewController
    constructor: (options) ->
      @instrument = options["instrument"]
      options["title"] = @instrument.get("sound").toString()
      super(options)

    loadView: ->
      @view = new InstrumentSettingsView(collection: window.soundManager.sounds, selected: @instrument.get("sound"))
      @view.selectView.bind("select", this._setSound)

    _setSound: (sound) =>
      @instrument.set(sound: sound)
