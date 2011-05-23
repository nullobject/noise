define ->
  class SelectView extends Backbone.View
    tagName:   "select"
    className: "select"

    events:
      "change": "_change"

    template: _.template """
      <% collection.each(function(model) { %><option><%= model.toString() %></option><% }); %>
    """

    constructor: (options) ->
      @selected = options["selected"]
      super(options)

    render: ->
      $(@el).html(@template(collection: @collection))
      console.log @selected
      this

    _change: (event) =>
      model = @collection.detect (model) ->
        model.toString() == event.target.value
      this.trigger("select", model) if model
