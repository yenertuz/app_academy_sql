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
			@attributes[single_column]
		end
		
		define_method(single_column.to_s + "=") do |parameter|
			@attributes[single_column] = parameter
		end
	end
	self.get_column_names
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
	self.attributes
	params.each_key do |key|
		raise ArgumentError.new "unknown attribute #{key}" if self.class.columns.include?(key.to_sym) == false
		@attributes[key.to_sym] = params[key]
	end
  end

  def attributes
	# ...
	return @attributes if @attributes != nil
	@attributes = {}
	self.class.columns.each do |single_column|
		@attributes[single_column] = nil
	end
	@attributes
  end

  def attribute_values
	# ...
	attribute_values = []
	if @@columns_without_id == nil 
		self.class.get_column_names
	end
	@@columns_without_id.each do |column_name|
		attribute_values << self.send(column_name)
	end
	attribute_values
  end

  def self.get_column_names
	@@columns_without_id = @columns.dup 
	@@columns_without_id.delete(:id)
	@@column_names = @@columns_without_id.join(", ")
	@@q_marks = (["?"] * (@@columns_without_id.length) ).join(", ")
  end

  def insert
	# ...
	query = <<-SQL
	INSERT INTO #{self.class.table_name}
	( #{@@column_names} )
	VALUES
	( #{@@q_marks} )
	SQL
	DBConnection.execute(query, *(self.attribute_values))
	@id = DBConnection.last_insert_row_id
  end

  def update
	# ...
	set_line = @@columns_without_id.join(" = ?, ") + " = ? "
	query = <<-SQL
	UPDATE #{self.class.table_name}
	SET 
	#{set_line}
	WHERE id = ?
	SQL
	DBConnection.execute(query, *(self.attribute_values), @id)
  end

  def save
	# ...
	if @attributes[id].nil?
		self.insert 
	else
		self.update 
	end
  end
end
