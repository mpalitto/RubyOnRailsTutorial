class User < ApplicationRecord
  has_secure_password
  validates_presence_of :email
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
  validates_uniqueness_of :email
end
