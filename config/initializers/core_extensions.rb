class String
  def to_class
    self.split("::").inject(Object) { |m, c| m.const_get(c) }
  end
end