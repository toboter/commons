require "shrine"
require "shrine/storage/file_system"

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new("../files", prefix: "uploads/cache"), # temporary
  store: Shrine::Storage::FileSystem.new("../files", prefix: "uploads/store"), # permanent
}
# https://github.com/jordanandree/shrine-scp

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data # for forms
Shrine.plugin :metadata_attributes