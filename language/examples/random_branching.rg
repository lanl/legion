
import "regent"
local c = regentlib.c


task rand_gen(init : int64) : int64
	var total : int64 = 0
	for i = 1,init do
		var decision = c.rand() % 2
		if decision == 0 then
			total += 1
		else
			total += rand_gen(init - 1) 	
		end
	end
	return total
end


-- Random branching behavior with no payload on the tasks

task main()
	var difficulty = 9
	c.srand(42)
	c.printf("%d\n", rand_gen(difficulty))
end

regentlib.start(main)


