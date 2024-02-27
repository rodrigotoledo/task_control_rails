# == Schema Information
#
# Table name: tasks
#
#  id           :bigint           not null, primary key
#  completed_at :datetime
#  scheduled_at :datetime
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
  end
end
