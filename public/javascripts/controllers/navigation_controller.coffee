define ->
  # Represents a view controller which manages hierarchical content.
  class NavigationController
    constructor: (rootViewController) ->
      @viewControllers = []
      this.pushViewController(rootViewController)

    pushViewController: (viewController) ->
      lastViewController = _(@viewControllers).last()
      this._removeView(lastViewController.view) if lastViewController

      viewController.navigationController = this
      this._appendView(viewController.view)
      @viewControllers.push(viewController)

      viewController

    popViewController: ->
      throw "can't pop root view controller" unless @viewControllers.length > 1

      viewController = @viewControllers.pop()
      this._removeView(viewController.view)
      viewController.navigationController = null

      lastViewController = _(@viewControllers).last()
      this._appendView(lastViewController.view)

      viewController

    _appendView: (view) ->
      $("#container").append(view.el)

    _removeView: (view) ->
      $(view.el).detach()
