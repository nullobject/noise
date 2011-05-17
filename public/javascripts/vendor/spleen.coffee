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
      @navigationItems = []

      @topNavigationItem  = null
      @backNavigationItem = null

      @leftButton  = new Spleen.Button(className: "left")
      @titleView   = new Spleen.Label(className: "title")

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

      if @backNavigationItem?
        el.append(@leftButton.render().el)
      else
        $(@leftButton.el).detach()

      el.append(@titleView.render().el)

      if @topNavigationItem?.rightButton?
        el.append(@topNavigationItem.rightButton.render().el)
      else if @backNavigationItem?.rightButton?
        $(@backNavigationItem.rightButton.el).detach()

      this

    _setButtonLabels: ->
      @leftButton.title = "← " + @backNavigationItem?.title
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
      @leftButton  = null
      @rightButton = null

      @title = options["title"]
