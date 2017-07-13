require "image_processing/mini_magick"
require "streamio-ffmpeg"
require 'exiftool'

class BaseUploader < Shrine
  plugin :signature
  plugin :determine_mime_type
  plugin :add_metadata
  plugin :metadata_attributes 
  Attacher.metadata_attributes :copyright => :copyright, :md5 => :signature
  
  add_metadata do |io, context|
    e = Exiftool.new(io.path)
    file = e.to_hash
    file.merge!({md5: calculate_signature(io, :md5)})
  end

end