class SubjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :attachment, :content_type, :copyright_owner, :copyright_license
end
