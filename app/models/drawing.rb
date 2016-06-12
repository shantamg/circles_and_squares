class Drawing < ActiveRecord::Base
  attr_accessible :name, :salt, :sprites_json, :user_id, :based_on, :likes, :complexity, :img
  before_save :data_massage

  def parseSprites
    (JSON.parse sprites_json).map do |s|
      OpenStruct.new s
    end
  end

  def camel_name
    name.gsub(/\s+/, "_").camelize
  end

  def self.weight(drawings, field)
    most = find(:first, select: field, order: "#{field} desc").send(field.to_sym).to_i
    least = find(:first, select: field, order: "#{field} asc").send(field.to_sym).to_i
    data = {}
    drawings.each do |d|
      data[d.id] = if most - least != 0
                     ((d.send(field.to_sym).to_i - least) * 10 / (most - least)).round # scale of 0 to 10
                   else
                     0
                   end
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
