define ["models/instrument"], (Instrument) ->
  describe "Instrument", ->
    instrument = new Instrument

    describe "#playNote", ->
      it "should play the given", ->
#         spyOn(instrument, "play")
        instrument.playNote(0)
#         expect(sequencer._triggerSound).toHaveBeenCalledWith(0, cell)
