class Subject < ApplicationRecord
  extend FriendlyId
  include Enki
  include Nabu
  include SearchCop

  before_validation :set_default_name, on: :create

  self.inheritance_column = :type
  friendly_id :obfuscated_id, use: :slugged
  acts_as_taggable

  validates :type, :name, :file_data, presence: true
  validates :file_signature, uniqueness: true

  def file_list=(names)
    self.tag_list = names
  end

  def self.types
    %w(Image Audio Video Document)
  end

  filterrific(
    default_filter_params: { sorted_by: 'modified_desc' },
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
    when /^modified_/
      order("subjects.updated_at #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }
   
  def self.options_for_sorted_by
    [
      ['Name (a-z)', 'name_asc'],
      ['Name (z-a)', 'name_desc'],
      ['Oldest first', 'modified_asc'],
      ['Newest first', 'modified_desc']
    ]
  end

  def recently_added
    created_at > Time.now - 30.minutes
  end


  def obfuscated_id
    SecureRandom.hex(10) # File.basename(attachment.filename, '.*').titleize if attachment.present?
  end

  private

  def set_default_name
    self.name = try(:file).try(:original_filename) || nil
  end

 
end
