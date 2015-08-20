#= require signup
describe "Signup Tracker", ->
  beforeEach ->
    window.ga = jasmine.createSpy("ga")
    window._fbq = jasmine.createSpyObj("fb", ["push"])
    window.heap = jasmine.createSpyObj("heap", ["track"])

    return

  it "should be a function", ->
    expect(track_lead_creation).not.toBeUndefined()
  it "does not raise an error", ->
    expect(track_lead_creation).not.toThrow()
  it "calls all expected functions", ->
    track_lead_creation()

    expect(ga).toHaveBeenCalled()
    expect(_fbq.push).toHaveBeenCalled()
    expect(heap.track).toHaveBeenCalled()