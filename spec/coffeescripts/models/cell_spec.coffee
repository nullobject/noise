define ["models/cell"], (Cell) ->
  describe "Cell", ->
    cell = new Cell

    describe "#getVector", ->
      it "should match for UP", ->
        cell.setState("up")
        expect(cell.getVector()).toEqual([0, -1])

      it "should match for DOWN", ->
        cell.setState("down")
        expect(cell.getVector()).toEqual([0, 1])

      it "should match for LEFT", ->
        cell.setState("left")
        expect(cell.getVector()).toEqual([-1, 0])

      it "should match for RIGHT", ->
        cell.setState("right")
        expect(cell.getVector()).toEqual([1, 0])

    describe "#isActive", ->
      describe "when state is null", ->
        it "should be false", ->
          cell.setState(null)
          expect(cell.isActive()).toBeFalsy()

      describe "when state is not null", ->
        it "should be true", ->
          cell.setState("up")
          expect(cell.isActive()).toBeTruthy()

    describe "#clear", ->
      it "should set the state to NULL", ->
        cell.setState("up")
        expect(cell.clear().getState()).toEqual(null)

    describe "#reverse", ->
      it "should reverse UP to DOWN", ->
        cell.setState("up")
        expect(cell.reverse().getState()).toEqual("down")

      it "should reverse DOWN to UP", ->
        cell.setState("down")
        expect(cell.reverse().getState()).toEqual("up")

      it "should reverse LEFT to RIGHT", ->
        cell.setState("left")
        expect(cell.reverse().getState()).toEqual("right")

      it "should reverse RIGHT to LEFT", ->
        cell.setState("right")
        expect(cell.reverse().getState()).toEqual("left")

    describe "#rotate", ->
      it "should rotate UP to RIGHT", ->
        cell.setState("up")
        expect(cell.rotate().getState()).toEqual("right")

      it "should rotate DOWN to LEFT", ->
        cell.setState("down")
        expect(cell.rotate().getState()).toEqual("left")

      it "should rotate LEFT to UP", ->
        cell.setState("left")
        expect(cell.rotate().getState()).toEqual("up")

      it "should rotate RIGHT to DOWN", ->
        cell.setState("right")
        expect(cell.rotate().getState()).toEqual("down")

    describe "#toggle", ->
      it "should toggle NULL to UP", ->
        cell.setState(null)
        expect(cell.toggle().getState()).toEqual("up")

      it "should toggle UP to RIGHT", ->
        cell.setState("up")
        expect(cell.toggle().getState()).toEqual("right")

      it "should toggle RIGHT to DOWN", ->
        cell.setState("right")
        expect(cell.toggle().getState()).toEqual("down")

      it "should toggle DOWN to LEFT", ->
        cell.setState("down")
        expect(cell.toggle().getState()).toEqual("left")

      it "should toggle LEFT to NULL", ->
        cell.setState("left")
        expect(cell.toggle().getState()).toEqual(null)
