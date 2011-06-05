define ->
  class Cell extends Backbone.Model
    defaults:
      state: null

    # State helper methods.
    getState:         -> this.get("state")
    setState: (value) -> this.set(state: value)

    # Column and row helper methods.
    getColumn: -> @column
    getRow:    -> @row

    initialize: (attributes, options) ->
      if options?
        @column = options["column"]
        @row    = options["row"]

    # Returns true if the cell is active, false otherwise.
    isActive: -> this.getState()?

    # Reverses the cell.
    reverse: ->
      this.setState(this._udlr("down", "up", "right", "left"))
      this

    # Rotates the cell clockwise.
    rotate: ->
      this.setState(this._udlr("right", "left", "up", "down"))
      this

    # Returns the cartesian vector for the cell.
    getVector: -> this._udlr([0, -1], [0, 1], [-1, 0], [1, 0])

    _udlr: (up, down, left, right) ->
      switch this.getState()
        when "up"    then up
        when "down"  then down
        when "left"  then left
        when "right" then right
        else throw "unknown state '#{this.getState()}'"
