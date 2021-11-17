require "employee"

class Startup

    attr_reader :name, :funding, :salaries, :employees
    def initialize(name, funding, salaries )
        @name = name
        @funding = funding 
        @salaries = salaries
        @employees = []
    end

    def valid_title?(title)
        @salaries.has_key?(title)
    end

    def > (other_startup)
        self.funding > other_startup.funding
    end

    def hire(name, title)
        if self.valid_title?(title)
            @employees << Employee.new(name, title)
        else
            raise "title is invalid!"
        end 
    end

    def size
        @employees.length
    end


    def pay_employee(employee)
        salary = @salaries[employee.title]
        if @funding >= salary
            employee.pay(salary)
            @funding -= salary
        else
            raise "Not enough funding"
        end
    end 

    def payday
        @employees.map do |employee|
            pay_employee(employee)
        end
    end

    def average_salary
        sum = 0
        @employees.map do |employee|
            sum += @salaries[employee.title]
        end
        sum / self.size
    end

    def close
        @employees = []
        @funding = 0
    end

    def acquire(other_startup)
        # add funding 
        @funding += other_startup.funding
        
        # merging salaries
        other_startup.salaries.each do |title, amount|
            if !@salaries.has_key?(title)
                @salaries[title] = amount
            end
        end

        #hire employees
        @employees += other_startup.employees
        other_startup.close
    end
end
