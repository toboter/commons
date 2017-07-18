class CommonSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::NumberHelper
  
  attributes :type, :name, :content_type
  attributes :links
  attributes :file_copyright, :file_copyright_details
  has_many :tags
  attributes :tags
  attributes :files


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
    object.tags.map{|c| c.name}.join(', ')
  end
  
  def files
    files=[]
    if object.file.is_a?(Hash)
      object.file.each do |key, version|
        files << {
            key.to_sym => {
              url: "#{Rails.application.secrets.host}#{version.url}",
              size: number_to_human_size(version.size)
            }
        }
      end
    else
      files << {
          original: {
            url: "#{Rails.application.secrets.host}#{object.file_url}"
          }
      }
    end
    files.reduce({}, :merge)
  end
   
end
