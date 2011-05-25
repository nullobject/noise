define ["views/instrument_settings_view"], (InstrumentSettingsView) ->
  class InstrumentSettingsViewController extends Spleen.ViewController
    constructor: (options) ->
      @instrument = options["instrument"]
      @instrument.bind("change:sound", this._setTitle)
      super(options)
      this._setTitle()

    loadView: ->
      @view = new InstrumentSettingsView(collection: window.soundManager.sounds, selected: @instrument.get("sound"))
      @view.selectView.bind("select", this._setSound)

    _setSound: (sound) =>
      @instrument.set(sound: sound)

    _setTitle: =>
      this.setTitle(@instrument.get("sound").toString())
