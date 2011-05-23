define ["views/select_view"], (SelectView) ->
  class InstrumentSettingsViewController extends Spleen.ViewController
    constructor: (options) ->
      @instrument = options["instrument"]
      options["title"] = @instrument.get("sample")

      super(options)

    loadView: ->
      @view = new SelectView(collection: window.soundManager)
#       @view.bind("select", (row) -> console.log row)
