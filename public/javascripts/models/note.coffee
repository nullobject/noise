define ->
  # Represents a note in a pattern.
  class Note extends Backbone.Model
    defaults:
      active: false
      gain:   0.0

    # Toggles whether the note is highlighted on/off.
    toggleActive: ->
      this.set(active: !this.get("active"))

    # Toggles the note on or off.
    toggle: ->
      if this.get("gain") > 0
        this.set(gain: 0.0)
      else
        this.set(gain: 1.0)
