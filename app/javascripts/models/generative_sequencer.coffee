define ["direction"], (Direction) ->
  # A generative sequencer represents a pattern of notes which move around
  # a grid and trigger sounds.
  #
  # The rules:
  #   * if the destination is off the grid then reverse the direction and trigger a sound.
  #   * if the destination is occupied by another note then rotate the direction
  #   * otherwise move the note to the destination.
  class GenerativeSequencer
    tick: (currentTime) ->
      _(@pattern.activeNotes).each (note) =>
        [columnOffset, rowOffset] = note.direction.getOffset()
        cell = @pattern.getCellAt(note.column + columnOffset, note.row + rowOffset)

        if !cell
          this._playNote(currentTime, note)
          note.direction.reverse()
        else if cell.note
          note.direction.rotate()
        else
          this._moveNoteToCell(note, cell)

    _moveNoteToCell: (note, cell) ->
      note.cell.note = null
      cell.note = note

    _playNote: (currentTime, note) ->
