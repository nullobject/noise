define ["sound_manager"], (SoundManager) ->
  describe "SoundManager", ->
    sound_manager = new SoundManager

    describe "#get", ->
      it "should return the sound with the given ID", ->
        sound = sound_manager.getSounds().add(id: "foo").last()
        expect(sound_manager.get("foo")).toEqual(sound)

    describe "#loadSound", ->
      it "should load the sound with the given ID from the given URL", ->
        loaded = false
        sound_manager.bind "all:loaded", -> loaded = true
        sound_manager.loadSound("bass_drum", "/sounds/808/bd.wav")
        waitsFor -> loaded
        runs -> expect(sound_manager.getSounds().last().getUrl()).toEqual("/sounds/808/bd.wav")

    describe "#loadSounds", ->
      it "should load the given sounds", ->
        spyOn(sound_manager, "loadSound")
        sound_manager.loadSounds(1: "foo", 2: "bar", 3: "baz")
        expect(sound_manager.loadSound).toHaveBeenCalledWith("1", "foo")
        expect(sound_manager.loadSound).toHaveBeenCalledWith("2", "bar")
        expect(sound_manager.loadSound).toHaveBeenCalledWith("3", "baz")
