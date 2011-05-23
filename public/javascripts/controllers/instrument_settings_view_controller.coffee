define ["views/select_view"], (SelectView) ->
  class InstrumentSettingsViewController extends Spleen.ViewController
    constructor: (options) ->
      @instrument = options["instrument"]
      options["title"] = @instrument.get("sound").toString()
      super(options)

    loadView: ->
      @view = new SelectView(collection: window.soundManager.sounds, selected: @instrument.get("sound"))
      @view.bind("select", this._setSound)

    _setSound: (sound) =>
      @instrument.set(sound: sound)
