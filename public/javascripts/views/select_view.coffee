define ->
  class SelectView extends Backbone.View
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
