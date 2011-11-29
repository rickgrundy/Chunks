class String
  def to_class
    self.split("::").inject(Object) { |m, c| m.const_get(c) }
  end
end

class Boolean
  def self.parse(val)
    ["TRUE", "T", "YES", "Y", "1"].include?(val.to_s.strip.upcase)
  end
end

class Array
  def delete_first_occurance(item)
    self.delete_at(self.index(item) || self.length)
  end
end