class Dog

	 attr_accessor :id, :name, :breed


	 def initialize(id: nil, name: , breed:)
	 	@id = id
	 	@name = name
	 	@breed = breed
	 end 

  	def self.create_table 
		DB[:conn].execute('DROP TABLE IF EXISTS dogs')
  		sql = <<-SQL
  			CREATE TABLE dogs 
  				(id INTEGER PRIMARY KEY,
  				 name TEXT,
  				 breed TEXT)
  		SQL
  		DB[:conn].execute(sql)
	end

	def self::drop_table 
		Dog.drop_table 
	end 

	def self.drop_table
		DB[:conn].execute("DROP TABLE dogs")
	end 

	def self::new_from_db(row)
		pet = Dog.new(row[0], row[1], row[2])
	end 

	def save
		if self.id
			self.update
		else 
			sql = <<-SQL
			INSERT INTO dogs (name, breed) 
			VALUES (?,?)
			SQL

			DB[:conn].execute(sql, self.name, self.breed)
			@id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
		end 
		self 
	end 


	def update
	sql = <<-SQL
			UPDATE dogs SET name = ?, breed =?
			WHERE id = ? 
			SQL

			DB[:conn].execute(sql, self.name, self.breed, self.id)
	end 

	def self.create(name: , breed: )
		@name = name
		@breed = breed
		new_dog = Dog.new(name: @name, breed: @breed)
		new_dog.save 
	end 

	def self::find_by_id(id_input)
		sql = <<-SQL
			SELECT * FROM dogs
			WHERE id = #{id_input}
			SQL
		row = DB[:conn].execute(sql)[0]
		new_dog = Dog.new(id: row[0], name: row[1], breed: row[2])
		new_dog
	end 

	def self::find_by_name(name_input)
		sql = <<-SQL
			SELECT * FROM dogs
			WHERE name = "#{name_input}"
			SQL
		row = DB[:conn].execute(sql)[0]
		new_dog = Dog.new(id: row[0], name: row[1], breed: row[2])
		new_dog
	end 


	def self::find_or_create_by(name: , breed: )
		@name = name
		@breed = breed
		sql = <<-SQL
			SELECT * FROM dogs
			WHERE name = ? AND breed = ?
			SQL
		row = DB[:conn].execute(sql, @name, @breed)[0]
		if row == nil 
			new_dog = Dog.create(name: @name, breed: @breed)
			new_dog.id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
			new_dog
		else 
			existing_dog = Dog.new(id: row[0], name: row[1], breed: row[2])
			existing_dog
		end 
	end 

	def self::new_from_db(row_array)
		new_dog = Dog.new(id: row_array[0], name: row_array[1], breed: row_array[2])
		new_dog
	end 

end 