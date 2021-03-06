require "chicago_employees/version"
require "unirest"

module ChicagoEmployees
  class Employee
  	attr_reader :title, :department, :name, :salary, :first_name, :last_name

  	def initialize(input_options)
  		@title = input_options["job_titles"]
  		@department = input_options["department"]
  		@name = input_options["name"]
  		@salary = input_options["employee_annual_salary"]
  		@first_name = @name.split(", ")[1]
  		@last_name = @name.split(", ")[0]
  	end

  	def self.all
  		Unirest.get("https://data.cityofchicago.org/resource/xzkq-xp2w.json")
  			.body
  			.map { |employee| Employee.new(employee) }
  	end

  	def self.find(parameter_option)
  		ruby_data = []
  		bulk_data = Unirest.get(
  			"https://data.cityofchicago.org/resource/xzkq-xp2w.json?department=#{parameter_option}"
  		).body
  		bulk_data.each do |employee|
  			ruby_data << Employee.new(employee)
  		end
  		ruby_data
  	end

  	def self.highest_paid_three
  		employees = Unirest.get("https://data.cityofchicago.org/resource/xzkq-xp2w.json")
  			.body
  			.map { |employee| Employee.new(employee) }
  		employees.max_by(3) { |employee| employee.salary }
  	end
  end
end
