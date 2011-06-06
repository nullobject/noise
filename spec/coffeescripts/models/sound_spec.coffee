define ["models/sound"], (Sound) ->
  describe "Sound", ->
    sound = new Sound(id: 1)

    describe "#toString", ->
      it "should return the ID", ->
        expect(sound.toString()).toEqual("1")

    describe "#play", ->
      it "should play the sound", ->
        # TODO
