class UuidValidator < ActiveModel::EachValidator
  @@uuid_regexp = /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i

  def validate_each(record, attribute, value)
    return if value.blank?
    unless value =~ @@uuid_regexp
      record.errors.add(attribute, options[:message] || 'is not a valid UUID')
    end
  end
end
