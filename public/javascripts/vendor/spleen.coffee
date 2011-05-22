window.Spleen = {}

# The current version.
Spleen.VERSION = "0.0.1"

# Represents a view controller.
#
# Each view controller is the sole owner of its view.
Spleen.ViewController =
  class
    # options:
    #   view: the view that the controller manages.
    constructor: (options = {}) ->
      @navigationController = null

      @title = options["title"]
      @view  = options["view"]

      @navigationItem = new Spleen.NavigationItem(title: @title)

      this.loadView() unless @view?
      @view.render() if @view?

    # Creates the view that the view controller manages. Override it with
    # your own view creation logic.
    loadView: ->

Spleen.Button =
  class extends Backbone.View
    tagName: "button"

    events:
      "click": "_click"

    initialize: ->
      @title = @options["title"]

    render: ->
      $(@el).text(@title || "")
      this

    _click: (event) =>
      this.trigger("click")

Spleen.Label =
  class extends Backbone.View
    tagName: "span"
    className: "label"

    initialize: ->
      @label = @options["label"]

    render: ->
      $(@el).text(@label || "")
      this

Spleen.NavigationBar =
  class extends Backbone.View
    tagName: "nav"

    initialize: ->
      @items = []

      @topItem  = null
      @backItem = null

      @_defaultTitleView = new Spleen.Label(className: "title")
      @_defaultLeftButton = new Spleen.Button(className: "left back")

      @titleView   = @_defaultTitleView
      @leftButton  = @_defaultLeftButton
      @rightButton = null

    pushNavigationItem: (item) ->
      @backItem = _(@items).last()
      @items.push(item)
      @topItem = item
      this.render()

    popNavigationItem: ->
      throw "Can't pop the root navigation item" unless @items.length > 1
      item = @items.pop()
      @topItem = _(@items).last()
      @backItem = @items[@items.length - 2]
      this.render()
      item

    render: ->
      this._updateTitleView()
      this._updateLeftButton()
      this._updateRightButton()

      @titleView.render()   if @titleView
      @leftButton.render()  if @leftButton
      @rightButton.render() if @rightButton

      this

    _updateTitleView: ->
      $(@titleView.el).detach() if @titleView

      @titleView = @topItem.titleView

      if !@titleView && @topItem
        @titleView = @_defaultTitleView
        @titleView.label = @topItem.title

      if @titleView
        $(@el).append(@titleView.el)

    _updateLeftButton: ->
      $(@leftButton.el).detach() if @leftButton

      @leftButton = @topItem.leftButton

      if !@leftButton && @backItem
        @leftButton = @_defaultLeftButton
#         @leftButton.title = @backItem.title

      if @leftButton
        @leftButton.bind("click", => this.trigger("pop", @topItem))
        $(@el).append(@leftButton.el)

    _updateRightButton: ->
      $(@rightButton.el).detach() if @rightButton

      @rightButton = @topItem.rightButton

      if @rightButton?
        $(@el).append(@rightButton.el)
        $(@rightButton.el).addClass("right")

# Represents a view controller which manages hierarchical content.
Spleen.NavigationController =
  class extends Spleen.ViewController
    # options:
    #   rootViewController: the top-level view controller in the stack.
    constructor: (options) ->
      @viewControllers   = []
      @topViewController = null

      super(options)

      @navigationBar = new Spleen.NavigationBar
      @navigationBar.bind("pop", this.popViewController)
      (@view.el).append(@navigationBar.el)

      rootViewController = options["rootViewController"]
      this.pushViewController(rootViewController) if rootViewController?

      @navigationBar.render()

    pushViewController: (viewController) =>
      this._swapViews(@topViewController?.view, viewController.view)

      @topViewController = viewController

      viewController.navigationController = this
      @viewControllers.push(viewController)

      @navigationBar.pushNavigationItem(viewController.navigationItem)

    popViewController: =>
      throw "Can't pop the root view controller" unless @viewControllers.length > 1

      @navigationBar.popNavigationItem()

      viewController = @viewControllers.pop()
      viewController.navigationController = null

      @topViewController = _(@viewControllers).last()

      this._swapViews(viewController.view, @topViewController.view)

      viewController

    _swapViews: (from, to) ->
      $(@view.el).append(to.el) if to?
      $(from.el).detach() if from?

Spleen.NavigationItem =
  class
    constructor: (options) ->
      @titleView   = null
      @leftButton  = null
      @rightButton = null

      @title = options["title"]
