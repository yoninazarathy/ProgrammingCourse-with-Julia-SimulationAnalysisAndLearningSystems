using MLDatasets
train_data = MLDatasets.MNIST.traindata(Float64)
imgs = train_data[1]
labels = train_data[2]

test_data = MLDatasets.MNIST.testdata(Float64)
test_imgs = test_data[1]
test_labels = test_data[2]
n_train, n_test = length(labels), length(test_labels)

X = vcat([vec(imgs[:,:,k])' for k in 1:last(size(imgs))]...)
Y = labels

X = vcat(X[Y .== 3,:], X[Y .== 8,:])
@show size(X)

Y = vcat(Y[Y .== 3], Y[Y .== 8])
@show length(Y);

mutable struct SplitNode
    feature::Int #1-784
    threshold::Float64
    lchild::Union{SplitNode,Nothing}
    rchild::Union{SplitNode,Nothing}
end

