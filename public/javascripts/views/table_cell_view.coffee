define ->
  class TableCellView extends Backbone.View
    tagName: "option"

    events:
      "click": "_click"

    initialize: ->
      @textLabel = new Spleen.Label
      $(@el).append(@textLabel.el)

    render: ->
      # TODO: delegate to get the label value.
      @textLabel.label = @model.toString()
      @textLabel.render()
      this

    _click: =>
      console.log "clicked"
