class SubjectSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::NumberHelper
  
  attributes :type, :name, :content_type
  attributes :links
  attributes :copyright_owner, :copyright_license
  has_many :tags
  attributes :tags
  attributes :attachment


  def type
    "Medium"
  end

  def links
    {
      self: api_medium_url(object, host: Rails.application.secrets.host),
      human: subject_url(object, host: Rails.application.secrets.host)
    }
  end

  def tags
    object.tags.map{|c| c.name}.join(', ')
  end
  
  def attachment
    {
      original_file: { 
        url: "#{Rails.application.secrets.host}#{object.attachment.url}",
        size: number_to_human_size(object.attachment.size),
        dimensions: object.dimensions
      },
      thumb_file: { 
        url: "#{Rails.application.secrets.host}#{object.attachment.thumb.url}",
        size: number_to_human_size(object.attachment.thumb.size)
      }
    }
  end
   
end
