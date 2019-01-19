class AttrAccessorObject
  def self.my_attr_accessor(*names)
	# ...
	names.each do |single|
		single = single.to_s
		define_method(single.to_sym) do
			self.instance_variable_get(("@" + single).to_sym)
		end

		define_method((single + "=").to_sym) do |parameter|
			self.instance_variable_set(("@" + single).to_sym, parameter)
		end
	  end
	  
	end
end
