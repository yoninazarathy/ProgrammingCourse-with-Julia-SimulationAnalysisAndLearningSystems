mutable struct Foo
    l_child::Union{Foo,Nothing}
    r_child::Union{Foo,Nothing}
    data::String

    #Here is also an inner constructor which is just the default inner constructor we would have had
    #unless we created the other one below
    Foo(l::Foo,r::Foo,d::String) = new(l,r,d)

    Foo(d::String) = new(nothing,nothing,d)

    function Foo() #Inner constructor can use the special keyword new()
        new(nothing,nothing,"") #call new in order of arguments 
    end

end

#This is also a constructor but an outer constructor... it can use inner constructors
function Foo(depth::Int)
    if depth == 0
        return Foo("leaf")
    else
        return Foo(Foo(depth-1),Foo(depth-1),"inner node")
    end
end

test = Foo(10)

test.l_child.r_child.data = "something else"