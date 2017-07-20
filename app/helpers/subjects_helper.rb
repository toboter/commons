module SubjectsHelper

  def render_thumb(subject, size=80)
    if subject.type == 'Image' || subject.type == 'Video'
      image_tag file_subject_url(subject, version: "thumb_#{size.to_s}".to_sym)
    elsif subject.type == 'Audio'
      fa_icon('file-audio-o 3x')
    elsif subject.type == 'Document'
      fa_icon('file-text-o 3x')
    else
      fa_icon('file-o 3x')
    end
  end

  def render_type_symbol(subject)
    if subject.type == 'Image'
      fa_icon('file-image-o')
    elsif subject.type == 'Video'
      fa_icon('file-video-o')
    elsif subject.type == 'Document'
      fa_icon('file-text-o')
    elsif subject.type == 'Audio'
      fa_icon('file-audio-o')
    else
      fa_icon('file-o')
    end
  end
end


