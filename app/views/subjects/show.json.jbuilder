json.extract! @subject, :id, :name, :attachment, :created_at, :updated_at
json.url subject_url(@subject, format: :json)