define ["controllers/view_controller", "controllers/pattern_view_controller", "views/kit_view"], (ViewController, PatternViewController, KitView) ->
  class KitViewController extends ViewController
    constructor: (options) ->
      @kit = options["kit"]
      @kit.bind("change:selected", this._instrumentSelected)
      super(options)

    loadView: ->
      @view = new KitView(model: @kit)

    _instrumentSelected: (instrument) =>
      instrument.set({selected: false}, {silent: true})
      this._openInstrument(instrument)

    _openInstrument: (instrument) ->
      patternViewController = new PatternViewController(title: instrument.get("sample"), pattern: instrument.get("pattern"))
      this.navigationController.pushViewController(patternViewController)
