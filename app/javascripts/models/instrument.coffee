define ->
  # An instrument represents a sound collection of sounds.
  class Instrument extends Backbone.Model
    defaults:
      sound: null

    # Sound accessor methods.
    getSound:         -> this.get("sound")
    setSound: (value) -> this.set(sound: value)

    # Plays the note at the given time.
    playNote: (time, note = "C", gain = 1.0) ->
      this.getSound().play(time, gain)
