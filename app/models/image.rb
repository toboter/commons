class Image < Subject
  include ImageUploader::Attachment.new(:file)

  def self.subtypes
    %w(jpg jpeg png gif tiff tif)
  end
  


end