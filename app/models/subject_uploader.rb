require 'exiftool'

class SubjectUploader < Shrine
  plugin :determine_mime_type
  plugin :add_metadata
  # plugin :metadata_attributes :copyright => :file_copyright

  add_metadata do |io, context|
    file = Exiftool.new(io.path)
    file.to_hash
  end

end