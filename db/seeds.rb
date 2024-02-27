# frozen_string_literal: true

30.times do |_i|
  task = Task.create(title: Faker::Lorem.question, scheduled_at: (Time.zone.now + 1.day))
  task.feature_image.attach(io: File.open(Rails.root.join('spec/support/ruby_on_rails.png')), filename: 'ruby_on_rails.png',
                            content_type: 'image/png')
  project = Project.create(title: Faker::Job.title)
  project.feature_image.attach(io: File.open(Rails.root.join('spec/support/ruby_on_rails.png')), filename: 'ruby_on_rails.png',
                               content_type: 'image/png')
end
