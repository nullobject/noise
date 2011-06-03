require priority: ["vendor/jquery", "vendor/underscore"]

require ["vendor/jquery", "vendor/underscore", "vendor/backbone", "spleen", "application"], (JQuery, Underscore, Backbone, Spleen, Application) ->
  application = new Application
