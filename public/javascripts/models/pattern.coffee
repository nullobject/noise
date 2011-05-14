define ["models/note"], (Note) ->
  # A pattern represents a collection of notes.
  class Pattern extends Backbone.Collection
    model: Note

    initialize: ->
      this.bind("add", this._addNote)
      _(@models).each(this._addNote)

    _addNote: (note) =>
      note.bind("change:active", this._noteActiveChanged)

    _noteActiveChanged: (note) =>
      return unless note.get("active")
      @activeNote.set(active: false) if @activeNote
      @activeNote = note
