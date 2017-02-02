module BenchmarkUtils

using Cairo, Gadfly, Colors

export run_test_compaign

function generateCombinations(optionslist, ret, depth , current)
    if depth == length(optionslist) + 1
        push!(ret, current)
        return
    end

    for i in range(1 , length(optionslist[depth]))
        generateCombinations(optionslist, ret, depth+1 , [current..., optionslist[depth][i]])
    end
end

function gen_colors(n)
  cs = distinguishable_colors(n,
      [colorant"#FE4365", colorant"#eca25c"], # seed colors
      lchoices=Float64[58, 45, 72.5, 90],     # lightness choices
      transform=c -> deuteranopic(c, 0.1),    # color transform
      cchoices=Float64[20,40],                # chroma choices
      hchoices=[75,51,35,120,180,210,270,310] # hue choices
  )
end

function plotMetric(dpoints, metric_name, folder)
# dpoints is a 2D np array (for a specific metric). each line has cat, conds, value

    # the space between each set of bars
    space = 0.3

    categories = convert(Array{String,1}, unique(dpoints[:,1]) )
    conditions = convert(Array{String,1}, unique(dpoints[:,2]) )

    n = length(conditions)
    cond_colors = gen_colors(n)
    nCategories = length(categories)

    # the width of each single bar. (1-space) is the width taken by all bars of one category
    width = (1 - space) / (length(conditions))
    indeces = collect(1:length(categories))
    max_y = 0.0
    p = 0 # I don't know how to create an empty plot with Gadfly
    for (i,cond) in enumerate(conditions)
        # @show cond
        vals = Array{Float64,1}()
        for k in 1:size(dpoints, 1)
            dpoints[k,2] == cond && push!(vals, dpoints[k,3])
        end
        # @show vals

        pos = [(j - (1 - space) / 2.0 + (i-0.5) * width) for j in indeces]
        # @show pos

        # @show pos .- (width/2.0)
        # @show pos .+ (width/2.0)

        if i == 1
            p = plot(xmin=pos .- (width/2.0), xmax=pos .+ (width/2.0), y=vals, Geom.bar,
                    Theme(default_color=cond_colors[i]) )
        else
            l = layer(xmin=pos .- (width/2.0), xmax=pos .+ (width/2.0), y=vals, Geom.bar,
                    Theme(default_color=cond_colors[i]) )
            push!(p,l)
        end

        max_y = max(max_y , maximum(vals))
    end

    push!(p, Guide.manual_color_key("", conditions, cond_colors) )
    push!(p, Coord.Cartesian(xmin=1-1.1, xmax=nCategories+1.1))
    push!(p, Guide.ylabel(metric_name))
    push!(p, Guide.xlabel(string([string(i,":",cat,"   ") for (i,cat) in enumerate(categories)]...)))
    push!(p, Guide.xticks(ticks=indeces))

    draw(PDF(string(folder,metric_name,".pdf"), 6inch, 4inch), p)
end


function run_test_compaign(categories, fixedparams, params, params_values, test_func, metrics, folder)

    params_values_list = []
    for p in params
        push!(params_values_list , params_values[p])
    end

    combs=[]
    generateCombinations(params_values_list, combs, 1, [])
    # @show combs

    dpoints_array = [[] for i in 1:length(metrics)]
    for cat in categories
        for comb in combs
            cond = ""
            for (i,p) in enumerate(params)
                cond = string(cond, p, comb[i])
                if i != length(params)
                    cond *= "-"
                end
            end
            result = test_func(cat, fixedparams..., comb...)
            for (i, met_val) in enumerate(result)
                # @show i
                push!(dpoints_array[i], [string(cat) cond met_val])
                # @show dpoints_array
            end
        end
    end
    # @show dpoints_array

    for (i, met_dpoints) in enumerate(dpoints_array)
        # @show met_dpoints
        met_dpoints_2D = vcat(met_dpoints...)
        metric_name = string(metrics[i])
        @show (met_dpoints_2D, metric_name)
        plotMetric(met_dpoints_2D, metric_name, folder)
    end
end


end # module
