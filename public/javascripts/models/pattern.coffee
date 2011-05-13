define ->
  # A pattern represents a collection of 16 notes.
  class Pattern extends Backbone.Model
    defaults:
      notes: Array(16)

    # Returns the note at the given index.
    getNote: (index) ->
      this.get("notes")[index]
