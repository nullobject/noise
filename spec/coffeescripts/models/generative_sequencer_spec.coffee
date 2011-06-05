define ["models/generative_sequencer"], (GenerativeSequencer) ->
  describe "GenerativeSequencer", ->
    sequencer = new GenerativeSequencer

    describe "#tick", ->
      it "should move the active cells", ->
        sequencer.getPattern().getCellAt(0, 0).setState("down")

        expect(sequencer.getPattern().getCellAt(0, 0).getState()).toEqual("down")
        expect(sequencer.getPattern().getCellAt(0, 1).getState()).toBeNull()
        sequencer.tick(0)
        expect(sequencer.getPattern().getCellAt(0, 0).getState()).toBeNull()
        expect(sequencer.getPattern().getCellAt(0, 1).getState()).toEqual("down")

      it "should reverse the direction of a cell which hits the edge of the pattern", ->
        sequencer.getPattern().getCellAt(3, 3).setState("down")

        expect(sequencer.getPattern().getCellAt(3, 3).getState()).toEqual("down")
        sequencer.tick(0)
        expect(sequencer.getPattern().getCellAt(3, 3).getState()).toEqual("up")

      it "should rotate the direction of a cell which hits another active cell", ->
        sequencer.getPattern().getCellAt(0, 0).setState("down")
        sequencer.getPattern().getCellAt(0, 1).setState("right")

        expect(sequencer.getPattern().getCellAt(0, 0).getState()).toEqual("down")
        sequencer.tick(0)
        expect(sequencer.getPattern().getCellAt(0, 0).getState()).toEqual("left")

      it "should trigger a sound when a cell hits the edge of the pattern", ->
        cell = sequencer.getPattern().getCellAt(3, 3).setState("down")

        spyOn(sequencer, "_triggerSound")
        sequencer.tick(0)
        expect(sequencer._triggerSound).toHaveBeenCalledWith(0, cell)
