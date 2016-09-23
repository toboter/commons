class Subject < ApplicationRecord
  include SearchCop
  mount_uploader :attachment, SubjectUploader
  
  validates :name, presence: true
  before_save :update_subject_attributes

  search_scope :search do
    attributes :name, :content_type
    #attributes :creator => ["creators.lname", "creators.fname"]
    #attributes :tag => "tags.name"
  end



  private

  def update_subject_attributes
    if attachment.present? && attachment_changed?
      self.content_type = attachment.content_type
      # self.file_size = attachment.size
    end
  end  
end
