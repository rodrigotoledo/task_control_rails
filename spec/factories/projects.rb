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
FactoryBot.define do
  factory :project do
    title { Faker::Lorem.sentence }
  end
end
