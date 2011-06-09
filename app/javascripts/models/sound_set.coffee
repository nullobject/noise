define ["models/sound"], (Sound) ->
  # Represents a collection of sounds.
  class SoundSet extends Backbone.Collection
    model: Sound
