define ->
  # Represents a cell in a grid which can be toggled on and off. A CellView
  # is backed by a Note model.
  class CellView extends Backbone.View
    tagName: "li"

    events:
      "click": "select"

    initialize: ->
      @model.bind("change", this.render)

    render: =>
      $(@el).toggleClass("active", @model.get("active")).toggleClass("selected", @model.get("selected"))

    select: =>
      @model.toggleSelected()
