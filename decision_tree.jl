using Plots, LinearAlgebra

x_seen = [-2, 3, 5, 6, 12, 14]
y_seen = [7, 2, 9, 3, 12, 3]
n = length(x_seen)

x_unseen = [15, -1, 5.5, 7.8]
y_unseen = [3.5, 6, 8.7, 10.4]

# Polynomial interpolation to fit exactly each point
V = [x_seen[i+1]^(j) for i in 0:n-1, j in 0:n-1]
c = V \ y_seen
f1(x) = c'*[x^i for i in 0:n-1]

#Linear fit
A = [ones(n) x_seen]
β = pinv(A)*y_seen
beta0, beta1 = 4.58, 0.17
f2(x) =β'*[1,x] 

xGrid = -5:0.01:20
plot(xGrid, f1.(xGrid), c=:blue, label="Exact Polynomial fit")
plot!(xGrid, f2.(xGrid), c=:red, label="Linear model")
scatter!(x_seen, y_seen, c=:black, shape=:diamond, ms=6, label="Seen Data points")
scatter!(x_unseen, y_unseen,
    c=:red, shape=:circle, ms=6,
    label="Unseen Data points", xlims=(-5,20), ylims=(-50,50),
    xlabel = "x", ylabel = "y"
)




using Distributions, Random, LaTeXStrings, Plots
Random.seed!(1)

d, k = 2, 3 #d features and k label types

make_data(class1 = 50, class2 = 30, class3 = 20) = 
                (vcat(   rand(MvNormal([1,1],[3 0.7; 0.7 3]), class1)', 
                        rand(MvNormal([4,2],[2.5 -0.7; -0.7 2.5]), class2)', 
                        rand(MvNormal([2,4],[2 0.7; 0.7 2]), class3)')
                        ,
                        vcat(fill(1,class1), fill(2,class2), fill(3,class3))
                        )

X, y = make_data()
n = length(y)
label_colors = [:red :green :blue]
xlim, ylim = (-3,8),(-3,8)

#We'll plot points again below, so putting it in in a function
plot_points(plt_function, X, y) = plt_function(X[:,1], X[:,2], c = label_colors, ms=5,
                                            group = y, xlabel=L"X_1", ylabel=L"X_2",
                                            xlim = xlim, ylim = ylim,legend=:topleft)
plot_points(scatter, X, y)



abstract type AbstractDecisionNode end

mutable struct DecisionNode <: AbstractDecisionNode
    # Cutoff logic
    feature::Int
    cutoff::Float64

    # Children - either another decision node
    lchild::Union{DecisionNode, Int64}
    rchild::Union{DecisionNode, Int64}
end




manual_tree = DecisionNode(
    1,   # 1st feature
    2.0, # Cutoff 2.0
    1,   # Left child is `1`
    2,   # Right child is `2`
)




function predict(node::AbstractDecisionNode, features::Vector{Float64})
    if features[node.feature] <= node.cutoff
        child = node.lchild
    else
        child = node.rchild
    end

    if child isa AbstractDecisionNode
        return predict(child, features)
    else
        return child
    end
end;




function tree_accuracy(tree, X, y)
    return mean(predict(tree, X[i,:]) == y[i] for i in 1:size(X)[1])
end

x1_grid = xlim[1]:0.005:xlim[2]
x2_grid = ylim[1]:0.005:ylim[2]
ccol = cgrad([RGB(1,0,0), RGB(0,1,0), RGB(0,0,1)])

function plot_decision(tree, X, y)
    contour(x1_grid, x2_grid, (x1,x2) -> predict(tree, [x1,x2]), 
            f = true, nlev = 3, c = ccol, legend = :none,
            title = "Training Accuracy = $(tree_accuracy(tree, X, y))")
    plot_points(scatter!, X, y)
end

plot_decision(manual_tree, X, y)




function Base.show(io::IO, node::AbstractDecisionNode, this_prefix = "", subtree_prefix = "")
    println(io, "$(this_prefix)─┬ feature[$(node.feature)] < $(node.cutoff)")

    # print children
    if node.lchild isa AbstractDecisionNode
        show(io, node.lchild, "$(subtree_prefix) ├", "$(subtree_prefix) │")
    else
        println(io, "$(subtree_prefix) ├── $(node.lchild)")
    end

    if node.rchild isa AbstractDecisionNode
        show(io, node.rchild, "$(subtree_prefix) └", "$(subtree_prefix)  ")
    else
        println(io, "$(subtree_prefix) └── $(node.rchild)")
    end
end

manual_tree




manual_tree.lchild = DecisionNode(
    2,
    1.9,
    3,
    1
)
manual_tree.rchild = DecisionNode(
    2,
    1.9,
    3,
    2
)
manual_tree




mutable struct DecisionNodeWithData <: AbstractDecisionNode
    # The data available to the node
    X::Matrix{Float64}
    y::Vector{Int}

    # Cutoff logic
    feature::Int
    cutoff::Float64

    # Children - either another decision node
    lchild::Union{DecisionNodeWithData, DecisionWithData}
    rchild::Union{DecisionNodeWithData, DecisionWithData}
end

mutable struct DecisionWithData
    # The data available to the leaf
    X::Matrix{Float64}
    y::Vector{Int}

    # Cutoff logic
    value::Int64
end

Base.show(io::IO, leaf::DecisionWithData) = Base.show(io, leaf.value)
predict(leaf::DecisionWithData, x) = leaf.value



#make an empty tree
init_tree(X, y) = DecisionWithData(X, y, 1); 
auto_split_tree = init_tree(X, y)




using StatsBase: mode #used here for finding the most common label 

function find_splitting_rule(leaf::DecisionWithData)
    X, y = leaf.X, leaf.y
    n, d = size(X)
    loss, τ, feature = Inf, NaN, -1
    pred_left_choice, pred_right_choice = -1, -1
    final_left_bits = BitVector()

    #Loop over all features
    for j = 1:d
        #Loop over all observations
        for i in 1:n
            τ_candidate = X[i,j]
            left_bits = X[:,j] .≤ τ_candidate
            right_bits = .!left_bits
            pred_left, pred_right = 0, 0

            (sum(left_bits) == 0 || sum(left_bits) == n) && continue

            pred_left = mode(y[left_bits])
            pred_right = mode(y[right_bits]) 
            new_loss = mean(y[left_bits] .!= pred_left) + mean(y[right_bits] .!= pred_right)

            #if found a better split than previously then retain it
            if new_loss < loss
                final_left_bits = left_bits
                pred_left_choice = pred_left
                pred_right_choice = pred_right
                feature = j
                τ = τ_candidate
                loss = new_loss
            end
        end
    end

    return (
        feature = feature,
        cutoff = τ, 
        left_value = pred_left_choice, 
        right_value = pred_right_choice, 
        left_bits = final_left_bits
    )
end;




function build_tree(leaf::DecisionWithData; max_depth = Inf, depth = 0)
    length(leaf.y) == 1 && return leaf
    length(unique(leaf.y)) ≤ 1 && return leaf
    (depth ≥ max_depth) && return leaf

    splitting_result = find_splitting_rule(leaf)
    right_bits = .!splitting_result.left_bits #.! flips the bits

    lchild = build_tree(
        DecisionWithData(
            leaf.X[splitting_result.left_bits,:], 
            leaf.y[splitting_result.left_bits], 
            splitting_result.left_value,
        ); max_depth = max_depth, depth = depth + 1
    )

    rchild =  build_tree(
        DecisionWithData(
            leaf.X[right_bits,:], 
            leaf.y[right_bits],  
            splitting_result.right_value,
        ); max_depth = max_depth, depth = depth + 1
    )

    return DecisionNodeWithData(
        leaf.X,
        leaf.y,
        splitting_result.feature,
        splitting_result.cutoff,
        lchild,
        rchild
    )
end;



auto_split_tree = build_tree(init_tree(X, y))
plot_decision(auto_split_tree, X, y)