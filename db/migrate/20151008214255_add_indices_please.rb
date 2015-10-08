class AddIndicesPlease < ActiveRecord::Migration
  def change
    add_index :recommendations, [:recommendable_id, :recommendable_type], name: 'recommendable_index'
    add_index :recommendations, :dashboard_id
    add_index :dashboards, :concierge_id
  end
end
