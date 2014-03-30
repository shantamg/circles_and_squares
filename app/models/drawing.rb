class Drawing < ActiveRecord::Base
  attr_accessible :name, :salt, :sprites_json, :user_id, :based_on, :likes, :complexity

  before_save :data_massage

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

  def self.weight(drawings, field)
    most = find(:first, select: field, order: "#{field} desc").send(field.to_sym)
    data = {}
    drawings.each do |d|
      data[d.id] = (d.send(field.to_sym) * 10 / most).round # scale of 0 to 10
    end
    data
  end

  private
    def data_massage
      self.salt = 1 + rand(8)
      self.name = "untitled" if name.strip == ''
      self.complexity = (sprites_json.length / 10).round
    end

end
