module DashboardsHelper
  def product_progress dashboard
    return 0 if dashboard.recommendations.products.count == 0
    done = dashboard.recommendations.products.done.count
    total = dashboard.recommendations.products.count
    return (done.to_f/total.to_f) * 100
  end
  def task_progress dashboard
    return 0 if dashboard.recommendations.tasks.count == 0
    done = dashboard.recommendations.tasks.done.count
    total = dashboard.recommendations.tasks.count
    return (done.to_f/total.to_f) * 100
  end
end