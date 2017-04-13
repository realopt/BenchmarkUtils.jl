# BenchmarkUtils

Tools to ease the setup of numerical experiments to benchmark algorithmic feature performances. The test automation permits to quickly calibrate the parameters of an arbitrary algorithm control function.

# Installation

To install please run the following command on Julia terminal

```
Pkg.clone("git@github.com:realopt/BenchmarkUtils.jl.git")
```

# Usage example

The following script 

```julia
using BenchmarkUtils

function test_func_example(cat, offset, s, p)
    if cat == :A
        return s + p + offset, s * p + offset
    else
        return 2 + s + p + offset, 2 * s * p + offset
    end
end

categories = [:A, :B]
fixedparams_values = [+10] # the <offset> in the test_func_example
varparams = [:s, :p]
varparams_values = Dict(:s => [1,2], :p => [3,4])
metrics = [:SumMetric, :ProdMetric]
folder = dirname(@__FILE__) * "/"  

run_test_compaign(categories, fixedparams_values, varparams, varparams_values, test_func_example, metrics, folder)
```

automatically produces those two files in a pdf format


![SumMetric](https://github.com/realopt/realopt.github.io/blob/master/BenchmarkUtils/metric2.png)

![ProdMetric](https://github.com/realopt/realopt.github.io/blob/master/BenchmarkUtils/metric1.png)






