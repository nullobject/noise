define ["models/instrument", "models/sound"], (Instrument, Sound) ->
  describe "Instrument", ->
    sound = new Sound
    instrument = new Instrument(sound: sound)

    describe "#playNote", ->
      it "should play the sound", ->
        spyOn(sound, "play")
        instrument.playNote(0)
        expect(sound.play).toHaveBeenCalledWith(0, 1.0)
