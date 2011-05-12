define ->
  class TriggerViewController
    constructor: (@el) ->
      @triggerViews = []

    addTriggerView: (triggerView) ->
      triggerView.render()
      $(@el).append(triggerView.el)
      @triggerViews.push(triggerView)
