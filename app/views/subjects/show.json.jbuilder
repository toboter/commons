json.files Array(@subject) do |subject|
  json.id subject.id
  json.name subject.name
  json.size subject.file.size
  json.url url_for(subject)
  json.thumbnailUrl subject.file_url(:thumb_40)
end