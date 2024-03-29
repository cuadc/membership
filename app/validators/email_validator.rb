class EmailValidator < ActiveModel::EachValidator
  @@email_regexp = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/

  def validate_each(record, attribute, value)
    return if value.blank?
    unless value =~ @@email_regexp
      record.errors.add(attribute, options[:message] || 'is not a valid email address')
    end
  end
end
