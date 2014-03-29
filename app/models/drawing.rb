class Drawing < ActiveRecord::Base
  attr_accessible :name, :salt, :sprites_json, :user_id, :based_on, :likes
  attr_accessor :sprites

  before_save :add_salt

  def to_param
    (id.to_s + salt.to_s).reverse.to_i.to_s(36)
  end

  def self.find_by_uid(uid)
    find(uid.to_i(36).to_s.reverse.chop)
  end

  def parseSprites
    (JSON.parse sprites_json).map do |s|
      OpenStruct.new s
    end
  end

  def camel_name
    name.gsub(/\s+/, "_").camelize
  end

  private
    def add_salt
      self.salt = 1 + rand(8)
    end

end
