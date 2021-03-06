require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
	keys_question_mark = params.keys.map do |key|
		"#{key.to_s} = ?"
	end
	keys_string = keys_question_mark.join(" AND ")

	result = DBConnection.execute(<<-SQL, *(params.values))
	SELECT * FROM #{self.table_name}
	WHERE #{keys_string}
	SQL
	parse_all(result)
  end
end

class SQLObject
	# Mixin Searchable here...
	
	extend Searchable

end
