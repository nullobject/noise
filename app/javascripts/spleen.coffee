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

      @view = options["view"]

      @navigationItem = new Spleen.NavigationItem(title: options["title"])

      this.loadView() unless @view?
      @view.render() if @view?

    # Creates the view which the view controller manages. Override it with
    # your own view creation logic.
    loadView: ->

    getTitle: ->
      @navigationItem.get("title")

    setTitle: (value) ->
      @navigationItem.set(title: value)

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
      @_text = @options["text"]

    render: ->
      $(@el).text(@_text || "")
      this

    getText: ->
      @_text

    setText: (value) ->
      @_text = value
      this.render()

Spleen.NavigationBar =
  class extends Backbone.View
    tagName: "nav"

    initialize: ->
      @items = []

      @topItem  = null
      @backItem = null

      @_defaultTitleView  = new Spleen.Label(className: "title")
      @_defaultLeftButton = new Spleen.Button(className: "back")

      @_defaultLeftButton.bind("click", => this.trigger("pop", @topItem))

      @_leftContainer   = $(document.createElement("div")).addClass("left")
      @_centerContainer = $(document.createElement("div")).addClass("center")
      @_rightContainer  = $(document.createElement("div")).addClass("right")

      $(@el).append(@_leftContainer, @_centerContainer, @_rightContainer)

      @leftButton  = @_defaultLeftButton
      @titleView   = @_defaultTitleView
      @rightButton = null

    pushNavigationItem: (item) ->
      @backItem = _(@items).last()
      @items.push(item)
      @topItem = item
      this.render()

    popNavigationItem: ->
      throw "Can't pop the root navigation item" unless @items.length > 1
      item = @items.pop()
      item.unbind("change:title")
      @topItem = _(@items).last()
      @backItem = @items[@items.length - 2]
      this.render()
      item

    render: ->
      this._updateTitleView()
      this._updateLeftButton()
      this._updateRightButton()

      @leftButton.render()  if @leftButton
      @titleView.render()   if @titleView
      @rightButton.render() if @rightButton

      this

    _updateLeftButton: ->
      $(@leftButton.el).detach() if @leftButton

      @leftButton = @topItem?.leftButton

      if !@leftButton && @backItem?
        @leftButton = @_defaultLeftButton
#         @leftButton.title = @backItem.title

      if @leftButton
        $(@_leftContainer).append(@leftButton.el)

    _updateTitleView: ->
      $(@titleView.el).detach() if @titleView

      @titleView = @topItem?.titleView

      if !@titleView && @topItem
        @titleView = @_defaultTitleView
        @topItem.bind "change:title", =>
          @titleView.setText(@topItem.get("title"))
        @topItem.trigger("change:title")

      if @titleView
        $(@_centerContainer).append(@titleView.el)

    _updateRightButton: ->
      $(@rightButton.el).detach() if @rightButton

      @rightButton = @topItem?.rightButton

      if @rightButton
        $(@_rightContainer).append(@rightButton.el)

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
  class extends Backbone.Model
    defaults:
      title: ""

    initialize: ->
      @titleView   = null
      @leftButton  = null
      @rightButton = null

Spleen.SelectView =
  class extends Backbone.View
    tagName:   "select"
    className: "select"

    events:
      "change": "_change"

    template: _.template """
      <% collection.each(function(model) { %><option><%= model.toString() %></option><% }); %>
    """

    initialize: ->
      @selected = @options["selected"]

    render: ->
      el = $(@el)
      el.html(@template(collection: @collection))
      el.val(@selected.toString())
      this

    _change: (event) =>
      model = @collection.detect (model) ->
        model.toString() == event.target.value
      this.trigger("select", model) if model
