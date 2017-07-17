class Document < Subject
  include DocumentUploader::Attachment.new(:file)

  def self.application_subtypes
    %w(
      pdf 
      vnd.oasis.opendocument.spreadsheet 
      vnd.ms-excel 
      vnd.openxmlformats-officedocument.spreadsheetml.sheet
      )
  end
  def self.text_subtypes
    %w(plain html csv)
  end

  
end