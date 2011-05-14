define ->
  class NoteView extends Backbone.View
    DRAG_THRESHOLD: 0.25

    tagName:   "li"
    className: "note"

    events:
      "mousedown": "_mouseDown"
      "mouseup":   "_mouseUp"
      "mousemove": "_mouseMove"
      "mouseout":  "_mouseOut"

    constructor: (options) ->
      @readonly = options["readonly"]
      super

    initialize: ->
      @model.bind("change", this.render)
      this.delegateEvents({}) if @readonly

    render: =>
      el = $(@el)
      @height = el.outerHeight()
      el.toggleClass("active", @model.get("active"))
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

    # Calculates the gain from the mouse Y offset within the note.
    _calculateGain: (event) ->
      (@height - event.offsetY - 1) / (@height - 1)

    _mouseDown: (event) =>
      @model.toggle()
      @dragging = false
      @startGain = this._calculateGain(event)

    _mouseUp: (event) =>
      @startGain = null
      @dragging = false

    _mouseMove: (event) =>
      gain = this._calculateGain(event)

      if @dragging
        gain = (Math.ceil(gain * 5) - 1) / 4
        @model.set(gain: gain)
      else if @startGain
        if Math.abs(gain - @startGain) >= this.DRAG_THRESHOLD
          @dragging = true

    _mouseOut: (event) =>
      @startGain = null
      @dragging = false
