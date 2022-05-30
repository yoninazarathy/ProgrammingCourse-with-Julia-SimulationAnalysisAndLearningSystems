using DataFrames, CSV, Random, LinearAlgebra, Statistics
using DecisionTree
using StatsBase: sample
using Plots

Random.seed!(0)
 
##################
# Prepare the data 
##################

cd(@__DIR__)
csv_file = CSV.File("../data/Melbourne_housing_FULL.csv"; missingstring = "")
df_full = DataFrame(csv_file)

vars_to_drop = ["Suburb","Address","Postcode","Lattitude","Longtitude","SellerG","Date","Method","CouncilArea","Propertycount","Regionname"]

df_partial = df_full[:,setdiff(names(df_full),vars_to_drop)]
df_imputed = dropmissing(df_partial)

df_imputed[!,:Distance] = parse.(Float64,df_imputed[:,:Distance])
df_imputed[!,:Price] = convert.(Float64,df_imputed[:,:Price])
df_imputed[!,:YearBuilt] = convert.(Float64,df_imputed[:,:YearBuilt])
df_imputed[!,:Landsize] = convert.(Float64,df_imputed[:,:Landsize])


prop_validate = 0.2
n = size(df_imputed)[1]
n_train = floor(Int,(1-prop_validate)*n)
n_validate = n - n_train
train_indexes = sample(1:n, n_train, replace = false)
validate_indexes = setdiff(1:n, train_indexes)

df_train = df_imputed[train_indexes,:]
X_train = Matrix(df_train[:,setdiff(names(df_train),["Price"])])
y_train = df_train.Price

df_validate = df_imputed[validate_indexes,:]
X_validate = Matrix(df_validate[:,setdiff(names(df_validate),["Price"])])
y_validate = df_validate.Price

function tree_losses(depth)
    model = DecisionTreeClassifier(max_depth=depth)
    fit!(model, X_train, y_train)
    # model = build_tree(y_train, X_train, size(X_train)[2], depth)
    # print_tree(model)

    y_hat_on_train = predict(model, X_train)#apply_tree(model,X_train)#
    l2_cost_train = sqrt(mean((y_train - y_hat_on_train).^2))

    y_hat_validate = predict(model, X_validate)#apply_tree(model,X_validate)
    l2_cost_validate = sqrt(mean((y_validate - y_hat_validate).^2))
    @show depth, l2_cost_train, l2_cost_validate;
    return l2_cost_train, l2_cost_validate;
end

tree_losses_log = tree_losses.(1:20)

min_validate_tree_loss = minimum(last.(tree_losses_log))
println("Minimum single tree validate loss: ", min_validate_tree_loss)

p_tree = plot(1:20,first.(tree_losses_log),label="traing",shape = :circle)
         plot!(1:20,last.(tree_losses_log),label="validate",xlabel="Depth",ylabel="Loss",shape = :circle)


####################
# Build Random Forest
####################


model = build_forest(y_train,X_train, 5, 40, 0.2, 5)

y_hat_on_train = apply_forest(model, X_train)
l2_cost_train = sqrt(mean((y_train - y_hat_on_train).^2))

y_hat_validate = apply_forest(model, X_validate)
l2_cost_validate = sqrt(mean((y_validate - y_hat_validate).^2))

println("Random forest validate loss: ", l2_cost_validate)

##################
# Our own bagging....
##################

function make_forest(X_train, y_train; num_bags = 10)
    forest = []
    n_train, d_features = size(X_train)
    d_s_features = floor(Int,sqrt(d_features))

    for i in 1:num_bags
        samples = sample(1:n_train, n_train, replace = true)
        features = sample(1:d_features, d_s_features, replace = false)
        X_train_bagged = X_train[samples, features]
        y_train_bagged = y_train[samples]

        model = build_tree(y_train_bagged, X_train_bagged,d_s_features,d_s_features)

        push!(forest, (model, features) )
    end
    return forest
end

function pred_forest(forest, X)
    y_hats = []
    for tree in forest
        # y_hat = predict(first(tree), X[:,:])
        y_hat = apply_tree(first(tree), X[:,last(tree)])

        push!(y_hats,y_hat)
    end
    return mean(y_hats)
end


for num_bags in 10:10:100
    forest = make_forest(X_train, y_train, num_bags=num_bags)
    y_hat_validate = pred_forest(forest, X_validate)
    l2_cost_validate = sqrt(mean((y_validate - y_hat_validate).^2))
    println("Our bagging of trees loss with $(num_bags) trees: ", l2_cost_validate)
end
####################
# Plot
####################

plot(p_tree)