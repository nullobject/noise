define ->
  class TriggerView extends Backbone.View
    tagName: "li"

    events:
      "click": "select"

    initialize: ->
      @model.bind("change", this.render)

    render: =>
      $(@el).toggleClass("selected", @model.get("selected"))

    select: =>
      @model.toggle()
