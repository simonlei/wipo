module AttachmentHelper

  def size_to_s size
    if size > GIGA 
      return (size/GIGA) .to_s + "GB"
    elsif size > MILLION
      return (size/MILLION) .to_s + "MB"
    elsif size > KILO
      return (size/KILO) .to_s + "KB"
    else
      return size.to_s + "B"
    end
  end
end
