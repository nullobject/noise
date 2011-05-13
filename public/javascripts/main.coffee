require priority: ["vendor/jquery", "vendor/underscore"]

require ["vendor/backbone", "vendor/jquery", "vendor/underscore", "controllers/application_view_controller"], (Backbone, JQuery, Underscore, ApplicationViewController) ->
  applicationViewController = new ApplicationViewController
