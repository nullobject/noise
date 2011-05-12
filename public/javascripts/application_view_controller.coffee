define ["sample_manager", "trigger", "trigger_view", "trigger_view_controller"], (SampleManager, Trigger, TriggerView, TriggerViewController) ->
  class ApplicationViewController
    constructor: ->
      this._initSampleManager()
      this._initTriggers()

    _initSampleManager: ->
      @sampleManager = new SampleManager

    _initTriggers: ->
      @triggerViewController = new TriggerViewController("#triggers")
      @triggers = _([0..15]).map =>
        trigger = new Trigger
        triggerView = new TriggerView(model: trigger)
        @triggerViewController.addTriggerView(triggerView)
        trigger
