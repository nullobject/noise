require priority: ["jquery", "underscore"]

require ["backbone", "jquery", "underscore", "application_view_controller"], (Backbone, JQuery, Underscore, ApplicationViewController) ->
  applicationViewController = new ApplicationViewController
