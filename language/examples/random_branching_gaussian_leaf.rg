
import "regent"
local c = regentlib.c
local math = terralib.includecstring [[
   #include <math.h>
]]

task getGaussian(variance : int64, mean : int64) : float
    --Create a gaussian random variable by using the box-muller transform
    --The uniform random variables need to be between 0 and 1
    --c.rand() is multiplied by 1.0 to force cast to float
    var uniform_random_1 : float = (c.rand() * 1.0) / c.RAND_MAX
    var uniform_random_2 : float = (c.rand() * 1.0) / c.RAND_MAX
    --The Box-Muller transform is used to turn these uniform random variables to a gaussian random variable
    return (math.sqrt(-2.0 * variance * math.log(uniform_random_1)) * math.cos(2.0 * math.M_PI * uniform_random_2)) + mean
end
    
task payload(init: int64) : int64
    --Create a dependency for which the process needs to return
    var total : int64 = 0
    for i = 1,init do
        total += i
    end
    --Wait some gaussian random number of time
    c.usleep(getGaussian(10, 100))
    return total
end 

task rand_gen(init : int64) : int64
	var total : int64 = 0
	for i = 1,init do
		var decision = c.rand() % 2
		if decision == 0 then
			total += payload(c.rand() % 10)
		else
			total += rand_gen(init - 1) 	
		end
	end
	return total
end


-- Random branching behavior with gaussian time payload on the tasks

task main()
	var difficulty : int64 = 12
	c.srand(42)
    c.printf("Difficulty: %d\n", difficulty)
    c.printf("%d\n", rand_gen(difficulty))
end

regentlib.start(main)


