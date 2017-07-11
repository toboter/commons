class Document < Subject
  include DocumentUploader::Attachment.new(:file)

  def self.application_subtypes
    %w(pdf vnd.oasis.opendocument.spreadsheet vnd.ms-excel)
  end
  def self.text_subtypes
    %w(plain html csv)
  end

  filterrific(
    default_filter_params: { sorted_by: 'created_at_desc' },
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
    when /^created_at_/
      order("subjects.created_at #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }
   
  def self.options_for_sorted_by
    [
      ['Name (a-z)', 'name_asc'],
      ['Name (z-a)', 'name_desc'],
      ['Oldest first', 'created_at_asc'],
      ['Newest first', 'created_at_desc']
    ]
  end
  
end