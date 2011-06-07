define ["models/cell"], (Cell) ->
  # A pattern represents a collection of cells.
  class Pattern extends Backbone.Collection
    @SIZE: 16

    model: Cell

    # Creates a new pattern.
    @createPattern: ->
      cells = _([0...@SIZE]).map (index) ->
        [column, row] = [index % 4, Math.floor(index / 4)]
        new Cell({}, {column: column, row: row})

      new Pattern(cells)

    # Returns the active cells in the pattern.
    getActiveCells: ->
      this.select (cell) -> cell.isActive()

    # Returns the cell at the given column and row.
    getCellAt: (column, row) ->
      if column >= 0 && column <= 3 && row >= 0 && row <= 3
        this.at((row * 4) + column)
      else
        null

    # Clears the cells in the pattern.
    clear: -> this.each (cell) -> cell.clear()
