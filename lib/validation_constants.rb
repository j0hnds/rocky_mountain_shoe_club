module ValidationConstants
  PHONE_REGEX ||= /^\d{3}-\d{3}-\d{4}$/
  EMAIL_REGEX ||= /^\b[A-Z0-9._%-]+@[A-Z0-9._-]+\.[A-Z_-]{2,4}\b$/i
  POSTAL_CODE_REGEX ||= /^\d{5}(-\d{1,5})?$/
end