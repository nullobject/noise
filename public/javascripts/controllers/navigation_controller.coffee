define ["controllers/view_controller"], (ViewController) ->
  # Represents a view controller which manages hierarchical content.
  class NavigationController extends ViewController
    class Button extends Backbone.View
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

    class Label extends Backbone.View
      tagName: "span"
      className: "label"

      initialize: ->
        @label = @options["label"]

      render: ->
        $(@el).text(@label || "")
        this

    class NavigationItem
      constructor: (options) ->
        @title = options["title"]

    class NavigationBar extends Backbone.View
      tagName: "nav"

      initialize: ->
        @navigationItems = []

        @topNavigationItem  = null
        @backNavigationItem = null

        @leftButton  = new Button(className: "left")
        @titleView   = new Label
#         @rightButton = new Button(className: "right")

      pushNavigationItem: (navigationItem) ->
        @backNavigationItem = _(@navigationItems).last()
        @navigationItems.push(navigationItem)
        @topNavigationItem = navigationItem
        this._setButtonLabels()
        this.render()

      popNavigationItem: ->
        throw "can't pop root navigation item" unless @navigationItems.length > 1
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
#         if @rightButton.label then el.append(@rightButton.render().el) else $(@rightButton.el).detach()

        this

      _setButtonLabels: ->
        @leftButton.label = "← " + @backNavigationItem?.title
        @titleView.label = @topNavigationItem?.title

    # options:
    #   rootViewController: the top-level view controller in the stack.
    constructor: (options) ->
      @viewControllers   = []
      @topViewController = null

      super(options)

      @navigationBar = new NavigationBar
      @navigationBar.leftButton.bind("click", this.popViewController)
      (@view.el).append(@navigationBar.render().el)

      rootViewController = options["rootViewController"]
      this.pushViewController(rootViewController) if rootViewController?

    pushViewController: (viewController) =>
      this._swapViews(@topViewController?.view, viewController.view)

      @topViewController = viewController

      viewController.navigationController = this
      @viewControllers.push(viewController)

      navigationItem = new NavigationItem(title: viewController.title)
      @navigationBar.pushNavigationItem(navigationItem)

    popViewController: =>
      throw "can't pop root view controller" unless @viewControllers.length > 1

      @navigationBar.popNavigationItem()

      viewController = @viewControllers.pop()
      viewController.navigationController = null

      @topViewController = _(@viewControllers).last()

      this._swapViews(viewController.view, @topViewController.view)

      viewController

    _swapViews: (from, to) ->
      $(@view.el).append(to.el) if to?
      $(from.el).detach() if from?
