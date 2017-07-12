json.files Array(@subject) do |subject|
  json.id subject.id
  json.name subject.name
  json.size subject.file.is_a?(Hash) ? subject.file[:original].size : subject.file.size
  json.url url_for(subject)
  if subject.type.in?(%w(Image Video))
    json.thumbnailUrl subject.file_url(:thumb_40)
  end
end