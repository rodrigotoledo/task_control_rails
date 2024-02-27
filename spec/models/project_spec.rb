# == Schema Information
#
# Table name: projects
#
#  id           :bigint           not null, primary key
#  completed_at :datetime
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'rails_helper'

RSpec.describe Project, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
  end
end
