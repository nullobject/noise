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
      @label = @options["label"]

    render: ->
      $(@el).text(@label || "")
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

Spleen.NavigationItem =
  class
    constructor: (options) ->
      @title = options["title"]

Spleen.NavigationBar =
  class extends Backbone.View
    tagName: "nav"

    initialize: ->
      @navigationItems = []

      @topNavigationItem  = null
      @backNavigationItem = null

      @leftButton  = new Spleen.Button(className: "left")
      @titleView   = new Spleen.Label(className: "title")
      @rightButton = new Spleen.Button(className: "right")

    pushNavigationItem: (navigationItem) ->
      @backNavigationItem = _(@navigationItems).last()
      @navigationItems.push(navigationItem)
      @topNavigationItem = navigationItem
      this._setButtonLabels()
      this.render()

    popNavigationItem: ->
      throw "Can't pop the root navigation item" unless @navigationItems.length > 1
      navigationItem = @navigationItems.pop()
      @topNavigationItem = _(@navigationItems).last()
      @backNavigationItem = @navigationItems[@navigationItems.length - 2]
      this._setButtonLabels()
      this.render()
      navigationItem

    render: ->
      el = $(@el)

      if @backNavigationItem? then el.append(@leftButton.render().el) else $(@leftButton.el).detach()
      el.append(@titleView.render().el)
      if @rightButton.label then el.append(@rightButton.render().el) else $(@rightButton.el).detach()

      this

    _setButtonLabels: ->
      @leftButton.label = "← " + @backNavigationItem?.title
      @titleView.label = @topNavigationItem?.title

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
      @navigationBar.leftButton.bind("click", this.popViewController)
      (@view.el).append(@navigationBar.render().el)

      rootViewController = options["rootViewController"]
      this.pushViewController(rootViewController) if rootViewController?

    pushViewController: (viewController) =>
      this._swapViews(@topViewController?.view, viewController.view)

      @topViewController = viewController

      viewController.navigationController = this
      @viewControllers.push(viewController)

      navigationItem = new Spleen.NavigationItem(title: viewController.title)
      @navigationBar.pushNavigationItem(navigationItem)

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
