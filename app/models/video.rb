class Video < Subject
  include VideoUploader::Attachment.new(:file)

  def self.subtypes
    %w(mp4)
  end

  
end