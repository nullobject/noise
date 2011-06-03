define ->
  class Cell extends Backbone.Model
    @UP:    0
    @DOWN:  1
    @LEFT:  2
    @RIGHT: 3

    initialize: ->
      @state = null

    # Reverses the cell.
    reverse: ->
      @state = this._udlr(Cell.DOWN, Cell.UP, Cell.RIGHT, Cell.LEFT)
      this

    # Rotates the cell clockwise.
    rotate: ->
      @state = this._udlr(Cell.RIGHT, Cell.LEFT, Cell.UP, Cell.DOWN)
      this

    # Returns the cartesian offset for the cell.
    getOffset: ->
      this._udlr([0, -1], [0, 1], [-1, 0], [1, 0])

    _udlr: (up, down, left, right) ->
      switch @state
        when Cell.UP    then up
        when Cell.DOWN  then down
        when Cell.LEFT  then left
        when Cell.RIGHT then right
        else throw "unknown state '#{@state}'"
