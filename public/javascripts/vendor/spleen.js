(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  window.Spleen = {};
  Spleen.VERSION = "0.0.1";
  Spleen.ViewController = (function() {
    function _Class(options) {
      if (options == null) {
        options = {};
      }
      this.navigationController = null;
      this.title = options["title"];
      this.view = options["view"];
      if (this.view == null) {
        this.loadView();
      }
      if (this.view != null) {
        this.view.render();
      }
    }
    _Class.prototype.loadView = function() {};
    return _Class;
  })();
  Spleen.Button = (function() {
    function _Class() {
      this._click = __bind(this._click, this);;      _Class.__super__.constructor.apply(this, arguments);
    }
    __extends(_Class, Backbone.View);
    _Class.prototype.tagName = "button";
    _Class.prototype.events = {
      "click": "_click"
    };
    _Class.prototype.initialize = function() {
      return this.label = this.options["label"];
    };
    _Class.prototype.render = function() {
      $(this.el).text(this.label || "");
      return this;
    };
    _Class.prototype._click = function(event) {
      return this.trigger("click");
    };
    return _Class;
  })();
  Spleen.Label = (function() {
    function _Class() {
      _Class.__super__.constructor.apply(this, arguments);
    }
    __extends(_Class, Backbone.View);
    _Class.prototype.tagName = "span";
    _Class.prototype.className = "label";
    _Class.prototype.initialize = function() {
      return this.label = this.options["label"];
    };
    _Class.prototype.render = function() {
      $(this.el).text(this.label || "");
      return this;
    };
    return _Class;
  })();
  Spleen.NavigationItem = (function() {
    function _Class(options) {
      this.title = options["title"];
    }
    return _Class;
  })();
  Spleen.NavigationBar = (function() {
    function _Class() {
      _Class.__super__.constructor.apply(this, arguments);
    }
    __extends(_Class, Backbone.View);
    _Class.prototype.tagName = "nav";
    _Class.prototype.initialize = function() {
      this.navigationItems = [];
      this.topNavigationItem = null;
      this.backNavigationItem = null;
      this.leftButton = new Spleen.Button({
        className: "left"
      });
      this.titleView = new Spleen.Label({
        className: "title"
      });
      return this.rightButton = new Spleen.Button({
        className: "right"
      });
    };
    _Class.prototype.pushNavigationItem = function(navigationItem) {
      this.backNavigationItem = _(this.navigationItems).last();
      this.navigationItems.push(navigationItem);
      this.topNavigationItem = navigationItem;
      this._setButtonLabels();
      return this.render();
    };
    _Class.prototype.popNavigationItem = function() {
      var navigationItem;
      if (!(this.navigationItems.length > 1)) {
        throw "Can't pop the root navigation item";
      }
      navigationItem = this.navigationItems.pop();
      this.topNavigationItem = _(this.navigationItems).last();
      this.backNavigationItem = this.navigationItems[this.navigationItems.length - 2];
      this._setButtonLabels();
      this.render();
      return navigationItem;
    };
    _Class.prototype.render = function() {
      var el;
      el = $(this.el);
      if (this.backNavigationItem != null) {
        el.append(this.leftButton.render().el);
      } else {
        $(this.leftButton.el).detach();
      }
      el.append(this.titleView.render().el);
      if (this.rightButton.label) {
        el.append(this.rightButton.render().el);
      } else {
        $(this.rightButton.el).detach();
      }
      return this;
    };
    _Class.prototype._setButtonLabels = function() {
      var _ref, _ref2;
      this.leftButton.label = "← " + ((_ref = this.backNavigationItem) != null ? _ref.title : void 0);
      return this.titleView.label = (_ref2 = this.topNavigationItem) != null ? _ref2.title : void 0;
    };
    return _Class;
  })();
  Spleen.NavigationController = (function() {
    __extends(_Class, Spleen.ViewController);
    function _Class(options) {
      this.popViewController = __bind(this.popViewController, this);;
      this.pushViewController = __bind(this.pushViewController, this);;      var rootViewController;
      this.viewControllers = [];
      this.topViewController = null;
      _Class.__super__.constructor.call(this, options);
      this.navigationBar = new Spleen.NavigationBar;
      this.navigationBar.leftButton.bind("click", this.popViewController);
      this.view.el.append(this.navigationBar.render().el);
      rootViewController = options["rootViewController"];
      if (rootViewController != null) {
        this.pushViewController(rootViewController);
      }
    }
    _Class.prototype.pushViewController = function(viewController) {
      var navigationItem, _ref;
      this._swapViews((_ref = this.topViewController) != null ? _ref.view : void 0, viewController.view);
      this.topViewController = viewController;
      viewController.navigationController = this;
      this.viewControllers.push(viewController);
      navigationItem = new Spleen.NavigationItem({
        title: viewController.title
      });
      return this.navigationBar.pushNavigationItem(navigationItem);
    };
    _Class.prototype.popViewController = function() {
      var viewController;
      if (!(this.viewControllers.length > 1)) {
        throw "Can't pop the root view controller";
      }
      this.navigationBar.popNavigationItem();
      viewController = this.viewControllers.pop();
      viewController.navigationController = null;
      this.topViewController = _(this.viewControllers).last();
      this._swapViews(viewController.view, this.topViewController.view);
      return viewController;
    };
    _Class.prototype._swapViews = function(from, to) {
      if (to != null) {
        $(this.view.el).append(to.el);
      }
      if (from != null) {
        return $(from.el).detach();
      }
    };
    return _Class;
  })();
}).call(this);
