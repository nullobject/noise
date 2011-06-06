define ->
  # An instrument represents a collection of sounds.
  class Instrument extends Backbone.Model
    defaults:
      sound: null

    # Sound accessor methods.
    getSound:         -> this.get("sound")
    setSound: (value) -> this.set(sound: value)

    # Updates the instrument state.
    tick: (time) -> throw "not implemented"

    # Plays a note.
    playNote: (time, note, gain) ->
      # TODO: look up the correct sound to play for the given note.
      sound = this.getSound()
      sound.play(time, gain) if sound
