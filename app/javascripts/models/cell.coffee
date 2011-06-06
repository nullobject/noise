define ->
  class Cell extends Backbone.Model
    defaults:
      state: null

    initialize: (attributes, options) ->
      if options?
        @column = options["column"]
        @row    = options["row"]

    # State accessor methods.
    getState:         -> this.get("state")
    setState: (value) -> this.set(state: value)

    # Column and row accessor methods.
    getColumn: -> @column
    getRow:    -> @row

    # Returns the cartesian vector for the cell.
    getVector: -> this._udlr([0, -1], [0, 1], [-1, 0], [1, 0])

    # Returns the target column and row for the cell.
    getTarget: ->
      vector = this.getVector()
      [this.getColumn() + vector[0], this.getRow() + vector[1]]

    # Returns true if the cell is active, false otherwise.
    isActive: -> this.getState()?

    # Reverses the cell.
    reverse: -> this.setState(this._udlr("down", "up", "right", "left"))

    # Rotates the cell clockwise.
    rotate: -> this.setState(this._udlr("right", "left", "up", "down"))

    # Toggles the cell through the states.
    toggle: ->
      switch this.getState()
        when "up", "down", "right" then this.rotate()
        when "left" then this.setState(null)
        else this.setState("up")

    _udlr: (up, down, left, right) ->
      switch this.getState()
        when "up"    then up
        when "down"  then down
        when "left"  then left
        when "right" then right
        else throw "unknown state '#{this.getState()}'"
