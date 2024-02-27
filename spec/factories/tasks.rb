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
FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence }
  end
end
