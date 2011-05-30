define ->
  class Direction
    @UP:    0
    @DOWN:  1
    @LEFT:  2
    @RIGHT: 3

    constructor: ->
      @value = null

    # Reverses the direction.
    reverse: ->
      this._udlr(Direction.DOWN, Direction.UP, Direction.RIGHT, Direction.LEFT)

    # Rotates the direction clockwise.
    rotate: ->
      this._udlr(Direction.RIGHT, Direction.LEFT, Direction.UP, Direction.DOWN)

    # Returns the cartesian offset for the direction.
    getOffset: ->
      this._udlr([0, -1], [0, 1], [-1, 0], [1, 0])

    _udlr: (up, down, left, right) ->
      switch @value
        when Direction.UP    then up
        when Direction.DOWN  then down
        when Direction.LEFT  then left
        when Direction.RIGHT then right
        else throw "unknown direction '#{@value}'"
