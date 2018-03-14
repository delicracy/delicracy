class YoutubeUrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, 'Invalid URL of Youtube.') unless Youtube.valid?(value)
  end
end
