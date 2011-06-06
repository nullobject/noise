define ["models/instrument", "models/pattern"], (Instrument, Pattern) ->
  # A generative sequencer represents a pattern of cells which move around
  # a grid and trigger sounds.
  class GenerativeSequencer extends Backbone.Model
    defaults:
      instrument: null
      pattern: null

    initialize: ->
      this.setInstrument(new Instrument) unless this.getInstrument()
      this.setPattern(Pattern.createPattern()) unless this.getPattern()

    # Instrument accessor methods.
    getInstrument:         -> this.get("instrument")
    setInstrument: (value) -> this.set(instrument: value)

    # Pattern accessor methods.
    getPattern:         -> this.get("pattern")
    setPattern: (value) -> this.set(pattern: value)

    # Moves the cells around according to the following rules:
    #   * if the target cell is off the edge of the pattern then reverse the
    #     direction and trigger a sound
    #   * if the target cell is occupied by another cell then rotate the direction
    #   * otherwise move the cell to the target cell
    tick: (time) ->
      _(this.getPattern().getActiveCells()).each (cell) =>
        [targetColumn, targetRow] = cell.getTarget()
        targetCell = this.getPattern().getCellAt(targetColumn, targetRow)

        if !targetCell
          this._triggerSound(time, cell)
          cell.reverse()
        else if targetCell.getState()
          cell.rotate()
        else
          this._moveCell(cell, targetCell)

    # Moves the given cell to the given target cell.
    _moveCell: (cell, targetCell) ->
      targetCell.setState(cell.getState())
      cell.setState(null)

    # Returns the row/column in which the cell collided with the edge of
    # the pattern.
    _getCollisionIndex: (cell) ->
      [targetColumn, targetRow] = cell.getTarget()

      if targetColumn < 0 || targetColumn > 3
        targetRow
      else if targetRow < 0 || targetRow > 3
        targetColumn
      else
        throw "cell did not collide"

    # TODO: calculate the note from the collision index.
    _getNote: (index) ->
      return "C"

    _triggerSound: (time, cell) ->
      index = this._getCollisionIndex(cell)
      note  = this._getNote(index)
      this.getInstrument().playNote(time, note)
