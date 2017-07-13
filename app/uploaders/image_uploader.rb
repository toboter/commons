class ImageUploader < BaseUploader
  include ImageProcessing::MiniMagick
  plugin :store_dimensions
  plugin :processing
  plugin :versions
  
  process(:store) do |io, context|
    original  = io.download
    size_1280 = resize_to_limit!(original, 1280, 1280) { |cmd| cmd.auto_orient } # orient rotated images
    size_640  = resize_to_limit(size_1280,  640, 640)
    size_320  = resize_to_limit(size_640,  320, 320)
    thumb_160 = resize_to_fill(size_320,  160, 160)
    thumb_80  = resize_to_fill(thumb_160,  80, 80)
    thumb_40  = resize_to_fill(thumb_80,  40, 40)
    {original: io, size_1280: size_1280, size_640: size_640, size_320: size_320, 
      thumb_160: thumb_160, thumb_80: thumb_80, thumb_40: thumb_40}
  end
end