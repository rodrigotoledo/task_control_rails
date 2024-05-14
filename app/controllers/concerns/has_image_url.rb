# app/controllers/concerns/has_image_url.rb
module HasImageUrl
  extend ActiveSupport::Concern

  def with_image_url(object, attachment_name)
    object_json = object.as_json
    attachment = object.send(attachment_name)
    object_json["#{attachment_name}_url"] = (rails_blob_path(attachment, only_path: true) if attachment.attached?)
    object_json
  end
end
