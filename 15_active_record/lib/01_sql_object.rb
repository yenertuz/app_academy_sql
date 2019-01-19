require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

def underscore(camel_cased_word)
	camel_cased_word.to_s.gsub(/::/, '/').
	  gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
	  gsub(/([a-z\d])([A-Z])/,'\1_\2').
	  tr("-", "_").
	  downcase + "s"
end

class SQLObject

  def self.columns
	# ...
	return @columns if @columns != nil
	self.table_name
	result = DBConnection.execute2(<<-SQL)
	SELECT * FROM #{self.table_name}
	SQL
	@columns = result[0].map { |column_s| column_s.to_sym }
	@columns
  end

  def self.finalize!
	self.columns if @columns == nil
	self.columns.each do |single_column|
		define_method(single_column) do
			self.instance_variable_get("@" + single_column.to_s)
		end
		
		define_method(single_column.to_s + "=") do |parameter|
			self.instance_variable_set("@" + single_column.to_s, parameter)
		end
	end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
	# ...s_string = se
	class_string = self.to_s
	@table_name = underscore(class_string) if (@table_name == nil || @table_name == "classs")
	@table_name
  end

  def self.all
	result = DBConnection.execute(<<-SQL)
	SELECT * FROM #{self.table_name}
	SQL
	result
	parse_all(result)
  end

  def self.parse_all(results)
	# ...
	results.map { |single_hash|   self.new(single_hash)  }
  end

  def self.find(id)
	result = DBConnection.execute(<<-SQL, id)
	SELECT * FROM #{self.table_name}
	WHERE id = ?
	LIMIT 1
	SQL
	self.new(result[0])
  end

  def initialize(params = {})
	# ...
	if @columns == nil
		@columns = self.class.columns
		self.class.finalize!
	end
	params.each_key do |key|
		raise ArgumentError.new "unknown attribute #{key}" if @columns.include?(key.to_sym) == false
		key_s = key.to_s
		self.instance_variable_set("@" + key_s, params[key])
	end
  end

  def attributes
    # ...
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
