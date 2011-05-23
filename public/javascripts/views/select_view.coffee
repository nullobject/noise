define ->
  class SelectView extends Backbone.View
    tagName:   "select"
    className: "select"

    events:
      "change": "_change"

    template: _.template """
      <% collection.each(function(model) { %><option><%= model.toString() %></option><% }); %>
    """

    render: ->
      $(@el).html(@template(collection: @collection))
      this

    _change: (event) =>
      selected = @collection.detect (model) ->
        model.toString() == event.target.value
      console.log selected
