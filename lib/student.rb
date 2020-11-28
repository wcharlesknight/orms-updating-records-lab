require_relative "../config/environment.rb"
require 'pry'

class Student

  attr_reader :id
  attr_accessor :name, :grade

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade   
  end 

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
      )
      SQL
  DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
        SQL
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
      #binding.pry
    end
  end 

  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS students 
      SQL
    DB[:conn].execute(sql)
  end

  def self.create(name, grade)
    students = Student.new(name, grade)
    students.save
    students 
  end 

  def self.new_from_db(row)
    new_student = self.create(row[1], row[2])
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end 

  def self.find_by_name(name) 
    sql = "SELECT * FROM students WHERE name = ?"
    result = DB[:conn].execute(sql, name)[0]
    #binding.pry
    Student.new(result[0],result[1], result[2])
    
  end   
  
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end
