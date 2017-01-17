#using BenchmarkUtils

#using Plots

include("../src/BenchmarkUtils.jl")

function test_func_example(cat, s, p)
    if cat == :A
        return s + p , s * p
    else
        return 2 + s + p , 2 * s * p
    end
end

categories = ["A", "B"]
params = ["s", "p"]
params_values = Dict("s" => [1,2], "p" => [3,4])
metrics = ["SumMetic", "ProdMetric"]
folder = "/Users/itahiri/GIT_REP/"

run_test_compaign(categories, params, params_values, test_func_example, metrics, folder)

# y=[3, 7, 5, 1]
# x=[1, 2, 3, 4]
# xmin1 = x .- 0.1
# xmax1 = x .+ 0.1
#
# xmin2 = x .- 0.5
# xmax2 = x .- 0.3
#
# function gen_colors(n)
#   cs = distinguishable_colors(n,
#       [colorant"#FE4365", colorant"#eca25c"], # seed colors
#       lchoices=Float64[58, 45, 72.5, 90],     # lightness choices
#       transform=c -> deuteranopic(c, 0.1),    # color transform
#       cchoices=Float64[20,40],                # chroma choices
#       hchoices=[75,51,35,120,180,210,270,310] # hue choices
#   )
# end
#
# mycolors = gen_colors(5)
#
#
# p = plot(#xmin=xmin1, xmax=xmax1,
#     x=["A","B","C","D"], y=[3, 7, 5, 1], Geom.bar,
#     xmin=xmin1, xmax=xmax1,
#     Theme(default_color=mycolors[1]) )
#
# # The following creates a new layer that keeps the same color
# #push!(p, layer(xmin=xmin2, xmax=xmax2, y=[3, 7, 5, 1], Geom.bar, order=2))
#
# # I do not want to use this because I don't know how many layers I will have
#
# # p = plot(x=[], y=[])
# #
# # push!(p, layer(xmin=xmin1, xmax=xmax1, y=[3, 7, 5, 1], Geom.bar,
# #     Theme(default_color=mycolors[1])   ))
# #
# # push!(p, layer(xmin=xmin2, xmax=xmax2, y=[3, 7, 5, 1], Geom.bar,
# #     Theme(default_color=mycolors[2])   ))
# #
# # push!(p, Guide.manual_color_key("", ["Thing One", "Thing Two"], [mycolors[1],mycolors[2]]) )
#
#
# # define a plot
# # myplot = plot(..)
# # draw(PDF("myplot.pdf", 4inch, 3inch), myplot)






