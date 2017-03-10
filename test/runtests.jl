using BenchmarkUtils

function test_func_example(cat, offset, s, p)
    if cat == :A
        return s + p + offset, s * p + offset
    else
        return 2 + s + p + offset, 2 * s * p + offset
    end
end

categories = [:A, :B]
fixedparams = [+10]
varparams = [:s, :p]
varparams_values = Dict(:s => [1,2], :p => [3,4])
metrics = [:SumMetric, :ProdMetric]
folder = dirname(@__FILE__) * "/"  # returns the directory absolute path of this file

run_test_compaign(categories, fixedparams, varparams, varparams_values, test_func_example, metrics, folder)
