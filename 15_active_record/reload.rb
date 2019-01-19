def reload 
	load "./lib/01_sql_object.rb"
	eval(<<~SQL)
	class Cat < SQLObject
	end
	Cat.finalize!
	SQL
	yener = Cat.new(name: "Yener")
end