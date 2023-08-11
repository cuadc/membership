module MemberHelper
  def get_lookup_attribute(data, attribName)
    data['attributes'].find { |attrib| attrib['scheme'] == attribName }.try(:dig, 'value')
  end

  def get_lookup_photo(data)
    data['attributes'].find { |attrib| attrib['scheme'] == 'jpegPhoto' }.try(:dig, 'binaryData')
  end
end
