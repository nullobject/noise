define ->
  # Represents a 4x4 grid of cells. A GridView is backed by a Pattern model.
  class GridView extends Backbone.View
    tagName: "ul"

    initialize: ->
      @model.bind("change", this.render)

    render: =>
      $(@el).addClass("grid")
