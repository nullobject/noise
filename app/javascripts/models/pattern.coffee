define ["models/cell"], (Cell) ->
  # A pattern represents a collection of cells.
  class Pattern extends Backbone.Collection
    model: Cell

    # Creates a new pattern.
    @createPattern: (size = 16) ->
      cells = _([0...size]).map -> new Cell
      new Pattern(cells)

    refresh: (models, options) ->
      super(models, options)
      @sqrt_size = Math.sqrt(this.size())
      this.each (cell, index) =>
        [column, row] = [index % @sqrt_size, Math.floor(index / @sqrt_size)]
        cell.setColumn(column).setRow(row)
      this

    # Returns the active cells in the pattern.
    getActiveCells: ->
      this.select (cell) -> cell.isActive()

    # Returns the cell at the given column and row.
    getCellAt: (column, row) ->
      if column >= 0 && column <= (@sqrt_size - 1) && row >= 0 && row <= (@sqrt_size - 1)
        this.at((row * @sqrt_size) + column)
      else
        null

    # Clears the cells in the pattern.
    clear: -> this.each (cell) -> cell.clear()
