define ["views/note_view"], (NoteView) ->
  class PatternView extends Backbone.View
    tagName:   "ul"
    className: "pattern"

    constructor: (options) ->
      @readonly = options["readonly"]
      super

    initialize: ->
      @model.bind("add", this._addCell)
      _(@model.models).each(this._addCell)
      this.delegateEvents({}) if @readonly

    render: =>
      $(@el)

    _addCell: (cell) =>
      noteView = new NoteView(model: cell, readonly: @readonly)
      noteView.render()
      $(@el).append(noteView.el)
