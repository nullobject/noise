define ->
  class InstrumentSettingsView extends Backbone.View
    tagName:   "ul"
    className: "form"

    template: _.template """
      <li>
        <label for="sound">Sound</label>
        <select id="sound"></sound>
      </li>
    """

    initialize: ->
      @selectView = new Spleen.SelectView(collection: @collection, selected: @options["selected"])

    render: ->
      $(@el).html(@template)

      @selectView.el = $("#sound", @el)
      @selectView.delegateEvents()
      @selectView.render()

      this
