class BaseStationConfigUpdatedField < ActiveRecord::Migration
  def up
    add_column "base_stations", "config_updated_at", :datetime
  end

  def down
    remove_column "base_stations", "config_updated_at"
  end
end
