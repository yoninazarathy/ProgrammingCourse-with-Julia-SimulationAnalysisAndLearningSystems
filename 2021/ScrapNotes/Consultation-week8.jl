
"""
This function takes an array `a` and returns the first element and removes it from the array
creating a new array which is smaller by one.

BAD!
"""
function my_pop!(a)
    isempty(a) && error("Can't pop from empty")
    ret_val = first(a)
    for i in 1:length(a)-1
        a[i] = a[i+1]
    end
    deleteat!(a,length(a))
    return ret_val
end

my_array = [1,2,3,4,5]

@show my_pop!(my_array)

@show my_array;