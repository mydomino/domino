class ChangeEnergyPlantoEnergyAnalysis < ActiveRecord::Migration
  def change
    rename_column :get_starteds, :energy_plan, :energy_analysis
  end
end
