class Subject < ApplicationRecord
  include SearchCop
  extend FriendlyId
  friendly_id :obfuscated_id, use: :slugged
  mount_uploader :attachment, SubjectUploader
  
  before_validation :set_default_name
  before_validation :update_subject_attributes, if: :attachment_changed?
  
  validates :name, :attachment, :content_type, presence: true

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  search_scope :search do
    attributes :name, :content_type
    #attributes :creator => ["creators.lname", "creators.fname"]
    attributes :tag => "tags.name"
  end

  def tag_list
    tags.map(&:name).join(", ")
  end
  
  def tag_list=(names)
    self.tags = names.reject { |c| c.empty? }.split(",").flatten.map do |n|
      Tag.where(name: n).first_or_create!
    end
  end

  def obfuscated_id
    SecureRandom.hex(10) # File.basename(attachment.filename, '.*').titleize if attachment.present?
  end

  private

  def set_default_name
    self.name = attachment_original_filename.split('.').first.titleize if attachment.present? && name.blank?
  end

  def update_subject_attributes
    if attachment.present? && attachment_changed?
      self.content_type = attachment.content_type
      self.attachment_size = attachment.size
      # attachment_created_at
      # self.attachment_original_filename = attachment.filename
    end
  end  
end
