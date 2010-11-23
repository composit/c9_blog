class Entry
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content
end
