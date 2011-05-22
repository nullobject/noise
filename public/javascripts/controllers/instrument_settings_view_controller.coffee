define ["views/table_view"], (TableView) ->
  class InstrumentSettingsViewController extends Spleen.ViewController
    constructor: (options) ->
      @instrument = options["instrument"]
      options["title"] = @instrument.get("sample")

      super(options)

    loadView: ->
      @view = new TableView(collection: window.soundManager)
#       @view.bind("select", (row) -> console.log row)
