module Http::URIAnalizer
  def extract_options_from(uri)
    if /(https?:\/\/.*\/)(.*)\// === slasherize(uri)
      { :host => $1.to_s, 
        :element => ActiveSupport::Inflector.singularize($2).to_s }
    else
      raise "The receiver uri '#{receiver_uri}' was not defined correctly."
    end
  end
  
  private
  def slasherize(string)
    if string.last == '/'
      string
    else
      string + "/"
    end
  end
end