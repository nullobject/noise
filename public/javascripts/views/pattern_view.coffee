define ["views/note_view"], (NoteView) ->
  class PatternView extends Backbone.View
    tagName:   "ul"
    className: "pattern"

    constructor: (options) ->
      @readonly = options["readonly"]
      super

    initialize: ->
      @model.bind("add", this._addNote)
      _(@model.models).each(this._addNote)
      this.delegateEvents({}) if @readonly

    render: =>
      $(@el)

    _addNote: (note) =>
      noteView = new NoteView(model: note, readonly: @readonly)
      noteView.render()
      $(@el).append(noteView.el)
