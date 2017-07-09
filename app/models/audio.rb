class Audio < Subject
  include AudioUploader::Attachment.new(:file)

  def self.subtypes
    %w(mp3)
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
    attributes :tag => "tags.name"
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
  
end