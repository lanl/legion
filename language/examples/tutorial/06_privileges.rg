-- Copyright 2016 Stanford University
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

import "regent"

local c = terralib.includec("stdlib.h")

fspace input {
  x : double,
  y : double,
}

fspace output {
  z : double,
}

task init(is : ispace(int1d),
          input_lr : region(is, input))
where writes(input_lr.{x, y}) do
  for i in is do
    input_lr[i].x = c.drand48()
    input_lr[i].y = c.drand48()
  end
end

task daxpy(is : ispace(int1d),
           input_lr : region(is, input),
           output_lr : region(is, output),
           alpha : double)
where reads writes(output_lr.z), reads(input_lr.{x, y}) do
  for i in is do
    output_lr[i].z = alpha*input_lr[i].x + input_lr[i].y
  end
end

task check(is : ispace(int1d),
           input_lr : region(is, input),
           output_lr : region(is, output),
           alpha : double)
where reads(input_lr, output_lr) do
  for i in is do
    var expected = alpha*input_lr[i].x + input_lr[i].y
    var received = output_lr[i].z
    regentlib.assert(expected == received, "check failed")
  end
end

task main()
  var num_elements = 1024
  var is = ispace(int1d, num_elements)
  var input_lr = region(is, input)
  var output_lr = region(is, output)

  init(is, input_lr)

  var alpha = c.drand48()
  daxpy(is, input_lr, output_lr, alpha)

  check(is, input_lr, output_lr, alpha)
end
regentlib.start(main)
