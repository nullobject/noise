define ["models/sound"], (Sound) ->
  # Represents a collection of sounds.
  class SoundSet extends Backbone.Model
    initialize: (attributes, options) ->
      @sounds = new Backbone.Collection([], {model: Sound})

    # Returns the sound for the given note.
    # TODO: look up the sound with the given note.
    getSound: (note) -> @sounds.first()

    # Returns the ID.
    toString: -> @id.toString()

    # Adds the given sound to the sound set.
    add: (sound) -> @sounds.add(sound)
