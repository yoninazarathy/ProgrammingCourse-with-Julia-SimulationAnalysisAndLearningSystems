#Here are parameters for scenarios 1, 2, 3, 4, 5 for Project 2
#For convenience they are stored in a struct, NetworkParameters

using Parameters #You need to install the Parameters.jl package: https://github.com/mauro3/Parameters.jl 
using LinearAlgebra 

#The @with_kw macro comes from the Parameters package
@with_kw struct NetworkParameters
    L::Int
    gamma_shape::Float64 #This is constant for all scenarios at 3.0
    λ::Float64 #This is undefined for the scenarios since it is varied
    η::Float64 #This is assumed constant for all scenarios at 4.0
    μ_vector::Vector{Float64} #service rates
    P::Matrix{Float64} #routing matrix
    Q::Matrix{Float64} #overflow matrix
    p_e::Vector{Float64} #external arrival distribution
    K::Vector{Int} #-1 means infinity 
end

############################
scenario1 = NetworkParameters(  L=3, 
                                gamma_shape = 3.0, 
                                λ = NaN, 
                                η = 4.0, 
                                μ_vector = ones(3),
                                P = [0 1.0 0;
                                    0 0 1.0;
                                    0 0 0],
                                Q = zeros(3,3),
                                p_e = [1.0, 0, 0],
                                K = fill(5,3))
@show scenario1

############################
scenario2 = NetworkParameters(  L=3, 
                                gamma_shape = 3.0, 
                                λ = NaN, 
                                η = 4.0, 
                                μ_vector = ones(3),
                                P = [0 1.0 0;
                                    0 0 1.0;
                                    0.5 0 0],
                                Q = zeros(3,3),
                                p_e = [1.0, 0, 0],
                                K = fill(5,3))
@show scenario2

############################
scenario3 = NetworkParameters(  L=3, 
                                gamma_shape = 3.0, 
                                λ = NaN, 
                                η = 4.0, 
                                μ_vector = ones(3),
                                P = [0 1.0 0;
                                    0 0 1.0;
                                    0.5 0 0],
                                Q = [0 0.5 0;
                                     0 0 0.5;
                                     0.5 0 0],
                                p_e = [1.0, 0, 0],
                                K = fill(5,3))
@show scenario3

############################
scenario4 = NetworkParameters(  L=5, 
                                gamma_shape = 3.0, 
                                λ = NaN, 
                                η = 4.0, 
                                μ_vector = collect(5:-1:1),
                                P = [0   0.5 0.5 0   0;
                                     0   0   0   1   0;
                                     0   0   0   0   1;
                                     0.5 0   0   0   0;
                                     0.2 0.2 0.2 0.2 0.2],
                                Q = [0 0 0 0 0;
                                     1 0 0 0 0;
                                     1 0 0 0 0;
                                     1 0 0 0 0;
                                     1 0 0 0 0],                             
                                p_e = [0.2, 0.2, 0, 0, 0.6],
                                K = [-1, -1, 10, 10, 10])
@show scenario4

############################
scenario5 = NetworkParameters(  L=20, 
                                gamma_shape = 3.0, 
                                λ = NaN, 
                                η = 4.0, 
                                μ_vector = ones(20),
                                P = zeros(20,20),
                                Q = diagm(3=>ones(19), -19=>ones(3)),                             
                                p_e = vcat(1,zeros(19)),
                                K = fill(5,20))
@show scenario5 