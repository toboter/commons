class Subject < ApplicationRecord
  extend FriendlyId
  include Enki
  include Nabu
  include SearchCop
  # include SubjectUploader[:file]

  before_validation :set_default_name, on: :create
  before_validation :set_type, if: :file_data_changed?

  self.inheritance_column = :type
  friendly_id :obfuscated_id, use: :slugged
  acts_as_taggable

  validates :type, :name, presence: true

  def self.types
    %w(Image Audio Video Document Subject)
  end
  
  filterrific(
    default_filter_params: { sorted_by: 'name_asc' },
    available_filters: [
      :sorted_by,
      :search
    ]
  )

  search_scope :search do
    attributes :name, :type
    attributes :tag => "tags.name" # verbunden mit AND suchen
  end

  scope :sorted_by, lambda { |sort_option|
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^name_/
      order("LOWER(subjects.name) #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }
   
  def self.options_for_sorted_by
    [
      ['Name (a-z)', 'name_asc'],
      ['Name (z-a)', 'name_desc']
    ]
  end


  def obfuscated_id
    SecureRandom.hex(10) # File.basename(attachment.filename, '.*').titleize if attachment.present?
  end

  private

  def set_type
    type = file.mime_type.split("/").first.classify
    self.type = type if Subject.types.include?(type)
  end

  def set_default_name
    self.name = file.original_filename
  end

 
end
