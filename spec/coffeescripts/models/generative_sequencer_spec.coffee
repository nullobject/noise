define ["models/generative_sequencer"], (GenerativeSequencer) ->
  describe "GenerativeSequencer", ->
    sequencer = new GenerativeSequencer

    beforeEach -> sequencer.getPattern().clear()

    describe "#tick", ->
      it "should move the active cells", ->
        sequencer.getPattern().getCellAt(0, 0).setState("down")
        sequencer.getPattern().getCellAt(0, 1).clear()
        sequencer.tick(0)
        expect(sequencer.getPattern().getCellAt(0, 0).getState()).toBeNull()
        expect(sequencer.getPattern().getCellAt(0, 1).getState()).toEqual("down")

      it "should reverse the direction of a cell which hits the edge of the pattern", ->
        sequencer.getPattern().getCellAt(0, 0).setState("up")
        sequencer.getPattern().getCellAt(3, 0).setState("right")
        sequencer.getPattern().getCellAt(0, 3).setState("left")
        sequencer.getPattern().getCellAt(3, 3).setState("down")
        sequencer.tick(0)
        expect(sequencer.getPattern().getCellAt(0, 0).getState()).toEqual("down")
        expect(sequencer.getPattern().getCellAt(3, 0).getState()).toEqual("left")
        expect(sequencer.getPattern().getCellAt(0, 3).getState()).toEqual("right")
        expect(sequencer.getPattern().getCellAt(3, 3).getState()).toEqual("up")

      it "should rotate the direction of a cell which hits another active cell", ->
        sequencer.getPattern().getCellAt(0, 0).setState("down")
        sequencer.getPattern().getCellAt(0, 1).setState("right")
        sequencer.tick(0)
        expect(sequencer.getPattern().getCellAt(0, 0).getState()).toEqual("left")
        expect(sequencer.getPattern().getCellAt(1, 1).getState()).toEqual("right")

      it "should trigger a sound when a cell hits the edge of the pattern", ->
        cell = sequencer.getPattern().getCellAt(3, 3).setState("down")
        spyOn(sequencer, "_triggerSound").andReturn(null)
        sequencer.tick(0)
        expect(sequencer._triggerSound).toHaveBeenCalledWith(0, cell)
