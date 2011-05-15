define ["controllers/view_controller"], (ViewController) ->
  # Represents a view controller which manages hierarchical content.
  class NavigationController extends ViewController
    class NavigationItem
      constructor: (options) ->
        @title = options["title"]

    class NavigationBar extends Backbone.View
      tagName: "nav"

      template: _.template """
        <% if (left) { %><span class="left"><%= left.title %></span><% } %>
        <% if (middle) { %><span class="middle"><%= middle.title %></span><% } %>
      """

      constructor: (options) ->
        @navigationItems    = []
        @topNavigationItem  = null
        @backNavigationItem = null

        super(options)

      pushNavigationItem: (navigationItem) ->
        @backNavigationItem = _(@navigationItems).last()
        @navigationItems.push(navigationItem)
        @topNavigationItem = navigationItem
        this.render()

      popNavigationItem: ->
        throw "can't pop root navigation item" unless @navigationItems.length > 1
        navigationItem = @navigationItems.pop()
        @topNavigationItem = _(@navigationItems).last()
        @backNavigationItem = _(@navigationItems).slice(-2, -1)
        this.render()
        navigationItem

      render: ->
        $(@el).html(@template(left: @backNavigationItem, middle: @topNavigationItem))

    # options:
    #   rootViewController: the top-level view controller in the stack.
    constructor: (options) ->
      @viewControllers   = []
      @topViewController = null

      super(options)

      @navigationBar = new NavigationBar
      @navigationBar.render()
      (@view.el).append(@navigationBar.el)

      rootViewController = options["rootViewController"]
      this.pushViewController(rootViewController) if rootViewController?

    pushViewController: (viewController) ->
      this._swapViews(@topViewController?.view, viewController.view)

      @topViewController = viewController

      viewController.navigationController = this
      @viewControllers.push(viewController)

      navigationItem = new NavigationItem(title: viewController.title)
      @navigationBar.pushNavigationItem(navigationItem)

    popViewController: ->
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
