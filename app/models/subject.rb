class Subject < ApplicationRecord
  extend FriendlyId
  friendly_id :obfuscated_id, use: :slugged
  acts_as_taggable
  mount_uploader :attachment, SubjectUploader

  self.inheritance_column = :_type_disabled

  before_validation :set_default_name, on: :create
  before_validation :set_type
  before_validation :update_subject_attributes, if: :attachment_changed?
  
  validates :attachment, :content_type, :type, presence: true
  
  def self.types
    %w(Image Audio Video Application)
  end

  def obfuscated_id
    SecureRandom.hex(10) # File.basename(attachment.filename, '.*').titleize if attachment.present?
  end
  
  def dimensions
    width && height ? "#{width} x #{height}" : nil
  end

  def self.filter_by(q)
    if q.present?
      tagged_with(q)
    else
      unscoped
    end
  end

  private

  def set_default_name
    self.name = attachment_original_filename.split('.').first.titleize if attachment.present? && name.blank?
  end

  def set_type
    type = attachment.content_type.split("/").first.classify
    self.type = type if Subject.types.include?(type)
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
