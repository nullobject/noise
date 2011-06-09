define ["sound_manager", "views/instrument_settings_view"], (SoundManager, InstrumentSettingsView) ->
  class InstrumentSettingsViewController extends Spleen.ViewController
    constructor: (options) ->
      @instrument = options["instrument"]
      @instrument.bind("change:sound", this._setTitle)
      super(options)
      this._setTitle()

    loadView: ->
      @view = new InstrumentSettingsView(collection: SoundManager.getInstance().getSounds(), selected: @instrument.get("sound"))
      @view.selectView.bind("select", this._setSound)

    _setSound: (sound) =>
      @instrument.set(sound: sound)

    _setTitle: =>
      this.setTitle(@instrument.get("sound").toString())
