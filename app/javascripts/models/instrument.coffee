define ->
  class Instrument extends Backbone.Model
    defaults:
      soundSet: null

    # Sound set accessor methods.
    getSoundSet:         -> this.get("soundSet")
    setSoundSet: (value) -> this.set(soundSet: value)

    # Updates the instrument state.
    tick: (time) -> throw "not implemented"

    # Plays a note.
    playNote: (time, note, gain) ->
      sound = this.getSoundSet().getSound(note)
      sound.play(time, gain) if sound
