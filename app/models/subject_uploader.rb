class SubjectUploader < Shrine
  plugin :determine_mime_type
end