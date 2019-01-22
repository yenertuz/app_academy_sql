def reload 
	load "./lib/03_associatable.rb"
	eval(<<~SQL)
	class Cat < SQLObject
	end
	Cat.finalize!
	SQL
	yener = Cat.new(name: "Yener")
end