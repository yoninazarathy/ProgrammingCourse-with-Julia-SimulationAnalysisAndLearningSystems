using StatsBase

"""
This function gives me the next queue to go to (either overflow or route-out if my current is q and I need to route according A)
"""
function my_rand_from_matrix(A::Matrix{Float64},q::Int)
    #First add another column to A which is the complement  
    # A is now larger by one column

    return sample(1:q,Weights(A[q,:]))
end