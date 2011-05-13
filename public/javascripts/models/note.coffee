define ->
  # Represents a note in a pattern.
  class Note extends Backbone.Model
    defaults:
      selected: false

    # Toggles the note on or off.
    toggle: ->
      this.set(selected: !this.get("selected"))
