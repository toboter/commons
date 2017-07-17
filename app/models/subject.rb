class Subject < ApplicationRecord
  extend FriendlyId
  include Enki
  include Nabu
  include SearchCop

  before_validation :set_default_name, on: :create
  after_validation :set_local_tags

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
      :search,
      :with_published_records,
      :with_unshared_records,
      :with_user_shared_to_like
    ]
  )

  scope :with_published_records, lambda { |flag|
    return nil  if 0 == flag # checkbox unchecked
    published_records
  }

  scope :with_unshared_records, lambda { |flag|
    return nil  if 0 == flag # checkbox unchecked
    inaccessible_records
  }

  scope :with_user_shared_to_like, lambda { |user_id|
    user = User.find(user_id)
    accessible_by_records(user)
  }

  search_scope :search do
    attributes :name, :type, :description, :file_copyright
    attributes :modified => "updated_at"
    attributes :tags => "local_tags"
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

  def set_local_tags
    self.local_tags = tag_list.join(', ')
  end
 
end
