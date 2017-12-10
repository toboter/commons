class CommonSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::NumberHelper
  
  attributes :type, :name, :content_type, :oid, :tags
  attributes :links
  attributes :file_copyright, :file_copyright_details
  attributes :files
  attributes :full_entry

  def full_entry
    object.name
  end

  def oid
    object.slug
  end

  def type
    object.type
  end

  def links
    {
      self: api_common_url(object, host: Rails.application.secrets.host),
      human: polymorphic_url(object, host: Rails.application.secrets.host)
    }
  end

  def tags
    object.local_tags
  end
  
  def files
    files=[]
    if object.file.is_a?(Hash)
      object.file.each do |key, version|
        files << {
            key.to_sym => {
              url: file_api_common_url(object, version: key, host: Rails.application.secrets.host),
              size: number_to_human_size(version.size),
              content_type: version.content_type,
              width: version.width,
              height: version.height
            }
        }
      end
    else
      files << {
          original: {
            url: file_subject_url(object, host: Rails.application.secrets.host),
            content_type: object.content_type
          }
      }
    end
    files.reduce({}, :merge)
  end
   
end
