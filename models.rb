require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/db/db.sqlite3")

class ExceptionEntry
  include DataMapper::Resource

  property :id,             Serial
  property :title,          String,   required: true, unique: true
  property :body,           Text,     required: true
  property :ip,             String,   required: true
  property :date_submitted, DateTime, default: lambda { |r, p| Time.now }
  property :resolved,       Boolean,  default: false
end

DataMapper.finalize
DataMapper.auto_upgrade!
