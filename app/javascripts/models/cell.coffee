define ->
  class Cell extends Backbone.Model
    defaults:
      state: null

    # State accessor methods.
    getState:         -> this.get("state")
    setState: (value) -> this.set(state: value)

    # Column accessor methods.
    getColumn:         -> @column
    setColumn: (value) -> @column = value; this

    # Row accessor methods.
    getRow:         -> @row
    setRow: (value) -> @row = value; this

    # Returns the cartesian vector for the cell.
    getVector: -> this._udlr([0, -1], [0, 1], [-1, 0], [1, 0])

    # Returns the target column and row for the cell.
    getTarget: ->
      vector = this.getVector()
      [this.getColumn() + vector[0], this.getRow() + vector[1]]

    # Returns true if the cell is active, false otherwise.
    isActive: -> this.getState()?

    # Clears the cell.
    clear: -> this.setState(null)

    # Reverses the cell.
    reverse: -> this.setState(this._udlr("down", "up", "right", "left"))

    # Rotates the cell clockwise.
    rotate: -> this.setState(this._udlr("right", "left", "up", "down"))

    # Toggles the cell through the states.
    toggle: ->
      switch this.getState()
        when "up", "down", "right" then this.rotate()
        when "left" then this.clear()
        else this.setState("up")

    _udlr: (up, down, left, right) ->
      switch this.getState()
        when "up"    then up
        when "down"  then down
        when "left"  then left
        when "right" then right
        else throw "unknown state '#{this.getState()}'"
