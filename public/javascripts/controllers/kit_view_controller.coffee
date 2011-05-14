define ["views/kit_view"], (KitView) ->
  class KitViewController
    constructor: (@kit) ->
      @kitView = new KitView(model: @kit)
      @kitView.render()
      $("#container").append(@kitView.el)
