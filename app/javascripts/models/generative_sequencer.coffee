define ["models/pattern"], (Pattern) ->
  # A generative sequencer represents a pattern of cells which move around
  # a grid and trigger sounds.
  class GenerativeSequencer extends Backbone.Model
    initialize: ->
      this.set(pattern: Pattern.createPattern())

    getPattern: -> this.get("pattern")

    # Moves the cells around according to the following rules:
    #   * if the target cell is off the edge of the pattern then reverse the
    #     direction and trigger a sound
    #   * if the target cell is occupied by another cell then rotate the direction
    #   * otherwise move the cell to the target cell
    tick: (currentTime) ->
      _(this.getPattern().getActiveCells()).each (cell) =>
        [columnOffset, rowOffset] = cell.getVector()
        targetCell = this.getPattern().getCellAt(cell.getColumn() + columnOffset, cell.getRow() + rowOffset)

        if !targetCell
          this._triggerSound(currentTime)
          cell.reverse()
        else if targetCell.getState()
          cell.rotate()
        else
          this._moveCell(cell, targetCell)

    _moveCell: (sourceCell, destinationCell) ->
      destinationCell.setState(sourceCell.getState())
      sourceCell.setState(null)

    _triggerSound: (currentTime) ->
      # TODO
