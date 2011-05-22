define ["views/scroll_view", "views/table_cell_view"], (ScrollView, TableCellView) ->
  class TableView extends ScrollView
    tagName:   "select"
    className: "table"

    initialize: ->
      _(@collection.models).each (model) =>
        tableCellView = new TableCellView(model: model)
        $(@el).append(tableCellView.render().el)
