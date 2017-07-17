class Audio < Subject
  include AudioUploader::Attachment.new(:file)

  def self.subtypes
    %w(mp3)
  end

  
end