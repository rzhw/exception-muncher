require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/db/db.sqlite3")

class User
  include DataMapper::Resource

  property :id,             Serial
  property :username,       Slug,       key: true, unique: true
  property :email,          String,     required: true, unique: true, format: :email_address
  property :password,       BCryptHash, required: true
end

class ExceptionEntry
  include DataMapper::Resource

  property :id,             Serial
  property :title,          String,     required: true
  property :body,           Text,       required: true
  property :ip,             String,     required: true
  property :date_submitted, DateTime,   default: lambda { |r, p| Time.now }
  property :resolved,       Boolean,    default: false

  def href
	"/admin/exception/#{id}"
  end
end

DataMapper.finalize
DataMapper.auto_upgrade!
