require priority: ["vendor/jquery", "vendor/underscore"]

require ["vendor/jquery", "vendor/underscore", "vendor/backbone", "controllers/application_view_controller"], (JQuery, Underscore, Backbone, ApplicationViewController) ->
  applicationViewController = new ApplicationViewController
