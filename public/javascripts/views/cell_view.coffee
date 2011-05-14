define ->
  # Represents a cell in a grid which can be toggled on and off. A CellView
  # is backed by a Note model.
  class CellView extends Backbone.View
    DRAG_THRESHOLD: 0.25

    tagName: "li"

    events:
      "mousedown": "_down"
      "mouseup":   "_up"
      "mousemove": "_move"
      "mouseout":  "_out"

    constructor: (options) ->
      super
      @gridView = options["gridView"]

    initialize: ->
      @model.bind("change", this.render)

    render: =>
      el = $(@el)
      @height = el.outerHeight()
      el.toggleClass("active", @gridView.controller.isActiveCell(this))
      el.removeClass("gain-0 gain-25 gain-50 gain-75 gain-100")
      el.addClass(this._getGainClass())
      el

    _getGainClass: ->
      gain = @model.get("gain")

      if gain == 1.0
        "gain-100"
      else if gain >= 0.75
        "gain-75"
      else if gain >= 0.50
        "gain-50"
      else if gain >= 0.25
        "gain-25"
      else
        "gain-0"

    # Calculates the gain from the mouse Y offset within the cell.
    _calculateGain: (event) ->
      (@height - event.offsetY - 1) / (@height - 1)

    _down: (event) =>
      @model.toggle()
      @dragging = false
      @startGain = this._calculateGain(event)

    _up: (event) =>
      @startGain = null
      @dragging = false

    _move: (event) =>
      gain = this._calculateGain(event)

      if @dragging
        gain = (Math.ceil(gain * 5) - 1) / 4
        @model.set(gain: gain)
      else if @startGain
        if Math.abs(gain - @startGain) >= this.DRAG_THRESHOLD
          @dragging = true

    _out: (event) =>
      @startGain = null
      @dragging = false
