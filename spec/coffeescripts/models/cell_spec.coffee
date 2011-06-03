define ["models/cell"], (Cell) ->
  describe "Cell", ->
    cell = new Cell

    describe "#state", ->
      it "should initially be null", ->
        expect(cell.state).toBeNull()

    describe "#reverse", ->
      it "should reverse UP to DOWN", ->
        cell.state = Cell.UP
        expect(cell.reverse().state).toEqual Cell.DOWN

      it "should reverse DOWN to UP", ->
        cell.state = Cell.DOWN
        expect(cell.reverse().state).toEqual Cell.UP

      it "should reverse LEFT to RIGHT", ->
        cell.state = Cell.LEFT
        expect(cell.reverse().state).toEqual Cell.RIGHT

      it "should reverse RIGHT to LEFT", ->
        cell.state = Cell.RIGHT
        expect(cell.reverse().state).toEqual Cell.LEFT

    describe "#rotate", ->
      it "should rotate UP to RIGHT", ->
        cell.state = Cell.UP
        expect(cell.rotate().state).toEqual Cell.RIGHT

      it "should rotate DOWN to LEFT", ->
        cell.state = Cell.DOWN
        expect(cell.rotate().state).toEqual Cell.LEFT

      it "should rotate LEFT to UP", ->
        cell.state = Cell.LEFT
        expect(cell.rotate().state).toEqual Cell.UP

      it "should rotate RIGHT to DOWN", ->
        cell.state = Cell.RIGHT
        expect(cell.rotate().state).toEqual Cell.DOWN

    describe "#getOffset", ->
      it "should match for UP", ->
        cell.state = Cell.UP
        expect(cell.getOffset()).toEqual [0, -1]

      it "should match for DOWN", ->
        cell.state = Cell.DOWN
        expect(cell.getOffset()).toEqual [0, 1]

      it "should match for LEFT", ->
        cell.state = Cell.LEFT
        expect(cell.getOffset()).toEqual [-1, 0]

      it "should match for RIGHT", ->
        cell.state = Cell.RIGHT
        expect(cell.getOffset()).toEqual [1, 0]
