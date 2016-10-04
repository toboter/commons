class Subject < ApplicationRecord
  include SearchCop
  mount_uploader :attachment, SubjectUploader
  
  before_validation :set_default_name
  before_validation :update_subject_attributes, if: :attachment_changed?
  
  validates :name, :attachment, :content_type, presence: true

  search_scope :search do
    attributes :name, :content_type
    #attributes :creator => ["creators.lname", "creators.fname"]
    #attributes :tag => "tags.name"
  end


  private

  def set_default_name
    self.name = File.basename(attachment.filename, '.*').titleize if attachment.present? && name.blank?
  end

  def update_subject_attributes
    if attachment.present? && attachment_changed?
      self.content_type = attachment.content_type
      # self.file_size = attachment.size
    end
  end  
end
