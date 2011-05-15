define ->
  # Represents a view controller.
  #
  # Each view controller is the sole owner of its view.
  class ViewController
    # options:
    #   view: the view that the controller manages.
    constructor: (options = {}) ->
      @navigationController = null
      @title                = options["title"]
      @view                 = options["view"]

      this.loadView() unless @view?
      @view.render() if @view?

    # Creates the view that the view controller manages. Override it with
    # your own view creation logic.
    loadView: ->
