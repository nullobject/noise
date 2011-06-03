define ["views/instrument_view"], (InstrumentView) ->
  class KitView extends Backbone.View
    tagName:   "ul"
    className: "kit"

    initialize: ->
      @model.bind("add", this._addInstrument)
      _(@model.models).each(this._addInstrument)

    _addInstrument: (instrument) =>
      instrumentView = new InstrumentView(model: instrument)
      instrumentView.render()
      $(@el).append(instrumentView.el)
