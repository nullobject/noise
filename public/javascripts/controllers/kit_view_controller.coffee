define ["controllers/pattern_view_controller", "views/kit_view"], (PatternViewController, KitView) ->
  class KitViewController
    constructor: (@kit) ->
      @kit.bind("change:selected", this._instrumentSelected)
      @view = new KitView(model: @kit)
      this._render()

    _render: ->
      @view.render()

    _instrumentSelected: (instrument) =>
      instrument.set({selected: false}, {silent: true})
      this._openInstrument(instrument)

    _openInstrument: (instrument) ->
      patternViewController = new PatternViewController(instrument.get("pattern"))
      this.navigationController.pushViewController(patternViewController)
