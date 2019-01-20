def reload 
	load "./lib/02_searchable.rb"
	eval(<<~SQL)
	class Cat < SQLObject
	end
	Cat.finalize!
	SQL
	yener = Cat.new(name: "Yener")
end