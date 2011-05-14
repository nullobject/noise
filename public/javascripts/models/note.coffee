define ->
  # Represents a note in a pattern.
  class Note extends Backbone.Model
    defaults:
      active:   false
      selected: false

    # Toggles the note on or off.
    toggleActive: ->
      this.set(active: !this.get("active"))

    # Toggles the note on or off.
    toggleSelected: ->
      this.set(selected: !this.get("selected"))
