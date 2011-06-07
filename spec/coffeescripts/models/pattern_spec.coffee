define ["models/pattern"], (Pattern) ->
  describe "Pattern", ->
    pattern = Pattern.createPattern()

    describe ".createPattern", ->
      it "should set the columns and rows of the cells", ->
        # TODO

    describe "#getActiveCells", ->
      describe "with no active cells", ->
        it "should return an empty array", ->
          expect(pattern.getActiveCells()).toEqual([])

      describe "with active cells", ->
        it "should return the active cells", ->
          cell = pattern.at(0)
          cell.setState("up")
          expect(pattern.getActiveCells()).toEqual([cell])

    describe "#getCellAt", ->
      it "should return the cell at the given column and row", ->
        cell = pattern.at(0)
        expect(pattern.getCellAt(0, 0)).toEqual(cell)

        cell = pattern.at(3)
        expect(pattern.getCellAt(3, 0)).toEqual(cell)

        cell = pattern.at(12)
        expect(pattern.getCellAt(0, 3)).toEqual(cell)

        cell = pattern.at(15)
        expect(pattern.getCellAt(3, 3)).toEqual(cell)

    describe "#clear", ->
      it "should clear the cells", ->
        # TODO
