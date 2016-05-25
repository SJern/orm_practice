require 'sqlite3'
require 'singleton'


# class DBConnectionBase
#
#   def initialize(dbname, type_translation, results_as_hash)
#     @connection_class_name = "#{dbname[0..-4].capitalize}DBConnection"
#     #connection_attributes = [dbname, type_translation, results_as_hash]
#
#     connection_class = Class.new(SQLite3::Database) do
#       include Singleton
#       @@dbname = dbname
#       @@type_translation = type_translation
#       @@results_as_hash = results_as_hash
#       #attr_accessor *attributes
#
#       def initialize
#         super(@@dbname)
#         self.type_translation = @@type_translation
#         self.results_as_hash = @@results_as_hash
#       end
#     end
#
#     Object.const_set @connection_class_name, connection_class
#   end
# end

class ModelBase
  attr_reader :connection_obj

  def initialize(db_connection_options = {})
    unless db_connection_options[:create_db].nil?

      dbname = db_connection_options[:dbname]


      connection_class_name = "#{dbname[0..-4].capitalize}DBConnection"
    #connection_attributes = [dbname, type_translation, results_as_hash]

      connection_class = Class.new(SQLite3::Database) do
        include Singleton
        @@dbname = dbname
        @@type_translation = true
        @@results_as_hash = true
        #attr_accessor *attributes

        def initialize
          super(@@dbname)
          self.type_translation = @@type_translation
          self.results_as_hash = @@results_as_hash
        end
      end

      Object.const_set connection_class_name, connection_class
    end

    ##anything else we want to do in the init
  end


  def self.find_by_id(id)
    array = @connection_class.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    return nil unless user.length > 0

    User.new(user.first)
  end

end
