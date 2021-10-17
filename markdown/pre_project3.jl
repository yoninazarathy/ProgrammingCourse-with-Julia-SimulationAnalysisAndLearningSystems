using DataFrames, CSV, Random, DecisionTree, StatsBase, LinearAlgebra
Random.seed!(0)
 
cd(@__DIR__)
csv_file = CSV.File("../data/Melbourne_housing_FULL.csv"; missingstring = "")
df_full = DataFrame(csv_file)
df = dropmissing(df_full[:,[:Price,:Suburb,:Rooms,:Bathroom,:Car,:YearBuilt,:Distance]])

prop_validate = 0.4
n = size(df)[1]
n_train = floor(Int,(1-prop_validate)*n)
n_validate = n - n_train
train_indexes = sample(1:n,n_train,replace = false)
validate_indexes = setdiff(1:n, train_indexes)

X = df[:,[:Rooms,:Bathroom,:Car,:YearBuilt]] |> Tables.Matrix |> float
Y = df.Price |> float



numFeaturesPerTree = 3
numTrees = 10
portionSamplesPerTree = 0.7
maxTreeDepth = 20

model = build_forest(Y[train_indexes], X[train_indexes,:], 
                    numFeaturesPerTree, numTrees, 
                    portionSamplesPerTree, maxTreeDepth)
println("Trained model:")
println(model)

Yhat = apply_forest(model, X[validate_indexes, :]) ;

loss = mean( (Yhat-Y[validate_indexes]).^2 )

@show loss;