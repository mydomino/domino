require "test_helper"
require "task"

class TaskTest < ActiveSupport::TestCase

  # test associations
  should have_many :recommendations

  should validate_inclusion_of(:icon).in_array(Task::ICON_OPTIONS)

  def setup
  	# using fixture data - refer to the fixture file name
    @task = tasks(:Task_1)
  end


  def test_valid
    assert @task.valid?
  end
end
