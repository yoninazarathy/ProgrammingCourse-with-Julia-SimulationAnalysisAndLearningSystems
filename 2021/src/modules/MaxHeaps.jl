"""
Module documentation here...
"""
module MaxHeaps

# Generally, put the exports at the top so they are easy to discover
export MaxHeap

mutable struct Node{T}
    parent::Union{Node{T}, Nothing}
    lchild::Union{Node{T}, Nothing}
    rchild::Union{Node{T}, Nothing}
    value::T

    Node{T}(value) where {T} = new(nothing, nothing, nothing, convert(T, value))
end

function sift_up!(node::Node)::Nothing
    if node.parent !== nothing && isless(node.parent.value, node.value)
        temp = node.value
        node.value = node.parent.value
        node.parent.value = temp
        sift_up!(node.parent)
    end
end

function sift_down!(node::Node)::Nothing
    # if there are no children then nothing to do
    if node.lchild === nothing && node.rchild === nothing
        return
    end

    # if there is only a left child...
    if node.lchild !== nothing && node.rchild === nothing
        if isless(node.value, node.lchild.value)
            temp = node.value
            node.value = node.lchild.value
            node.lchild.value = temp
            sift_down!(node.lchild)
        end
        return
    end

    # if here then there are two children

    # if node is larger than both children then return
    if isless(node.rchild.value, node.value) && isless(node.lchild.value, node.value)
        return
    end
    
    # if here then at least one of the children is larger than the node - swap now with the larger one
    if isless(node.lchild.value, node.rchild.value)  # if the right one is larger
        temp = node.value
        node.value = node.rchild.value
        node.rchild.value = temp
        sift_down!(node.rchild)
    else  # if the left on is larger
        temp = node.value
        node.value = node.lchild.value
        node.lchild.value = temp
        sift_down!(node.lchild)
    end
end

function show_node(io::IO, node::Node, this_prefix = "", subtree_prefix = "")
    print(io, "\n", this_prefix, node.lchild === nothing ? "── " : "─┬ ")
    show(io, node.value)

    # print children
    if node.lchild !== nothing
        if node.rchild !== nothing
            show_node(io, node.lchild, "$(subtree_prefix) ├", "$(subtree_prefix) │")
        else
            show_node(io, node.lchild, "$(subtree_prefix) └", "$(subtree_prefix)  ")
        end
    end
    if node.rchild !== nothing
        show_node(io, node.rchild, "$(subtree_prefix) └", "$(subtree_prefix)  ")
    end
end

mutable struct BalancedBinaryTree{T}
    num_nodes::Int
    root::Union{Node{T}, Nothing}

    BalancedBinaryTree{T}() where {T} = new(0, nothing)
end

depth(tree::BalancedBinaryTree) = 8*sizeof(Int) - leading_zeros(tree.num_nodes)

function last_node(tree::BalancedBinaryTree)::Node
    (tree.num_nodes == 1) && (return tree.root)

    num = tree.num_nodes
    current_node = tree.root
    bit_position = depth(tree) - 1
    mask = 1 << (bit_position-1)  # start reading from the (almost) MSB and mask shifts right
    while true
        if num & mask != 0  # If bit is "1" then go right
            if mask == 1 
                return current_node.rchild
            else  # not last one on the right
                current_node = current_node.rchild 
            end
        else  # If here then bit is "0" and go left
            if mask == 1
                return current_node.lchild
            else  # not last one on the left
                current_node = current_node.lchild
            end
        end
        mask >>= 1
    end
end

function Base.push!(tree::BalancedBinaryTree, value::String)::BalancedBinaryTree
    new_node = Node(value)
    
    # If tree is empty just add a root
    if tree.num_nodes == 0
        tree.root = new_node
        tree.num_nodes = 1
        return tree
    end

    # Otherwise, walk the tree based on the bit representation 
    tree.num_nodes += 1 
    num = tree.num_nodes  # This is the new node number we want to put in
    current_node = tree.root
    bit_position = depth(tree) - 1
    mask = 1 << (bit_position - 1)  # start reading from the (almost) MSB and mask shifts right
    while true
        if num & mask != 0  # If bit is "1" then go right
            if mask == 1  # last on right
                current_node.rchild = new_node
                new_node.parent = current_node
                break
            else  # not last one on the right
                current_node = current_node.rchild 
            end
        else  # If here then bit is "0" and go left
            if mask == 1  # last on left
                current_node.lchild = new_node
                new_node.parent = current_node
                break
            else  # not last one on the left
                current_node = current_node.lchild
            end
        end
        mask >>= 1
    end
    return tree
end

function Base.pop!(tree::BalancedBinaryTree)::String
    ret_val = tree.root.value
    
    # if there is only the root then remove it
    if tree.num_nodes == 1
        tree.root = nothing
        tree.num_nodes = 0
        return ret_val
    end

    # Otherwise, find the last node and put it in place of the root 
    num = tree.num_nodes
    current_node = tree.root
    bit_position = depth(tree) - 1
    mask = 1 << (bit_position - 1)  # start reading from the (almost) MSB and mask shifts right
    while true
        if num & mask != 0  # If bit is "1" then go right
            if mask == 1
                node_to_replace_with_root = current_node.rchild
                current_node.rchild = nothing
                node_to_replace_with_root.parent = nothing
                node_to_replace_with_root.rchild = tree.root.rchild
                node_to_replace_with_root.lchild = tree.root.lchild
                tree.root = node_to_replace_with_root
                break
            else  # not last one on the right
                current_node = current_node.rchild 
            end
        else  # If here then bit is "0" and go left
            if mask == 1
                node_to_replace_with_root = current_node.lchild
                current_node.lchild = nothing
                node_to_replace_with_root.parent = nothing
                node_to_replace_with_root.rchild = tree.root.rchild
                node_to_replace_with_root.lchild = tree.root.lchild
                tree.root = node_to_replace_with_root                
                break
            else  # not last one on the left
                current_node = current_node.lchild
            end
        end
        mask >>= 1
    end

    tree.num_nodes -=1

    return ret_val
end

function Base.show(io::IO, tree::BalancedBinaryTree{T}) where {T}
    print(io, "$(tree.num_nodes)-element BalancedBinaryTree{$T}")
    if tree.num_nodes > 0
        show_node(io, tree.root)
    end
end

"""
    MaxHeap{T}()

Return an empty `MaxHeap` that can hold elements of type `T` (which defaults to `Any`).

Items can be added using `push!` and removed using `pop!`. The maximum item is always
returned by `pop!`.
"""
struct MaxHeap{T}
    tree::BalancedBinaryTree{T}

    MaxHeap{T}() where {T} = new(BalancedBinaryTree{T}())
end

MaxHeap() = MaxHeap{Any}()

function Base.push!(heap::MaxHeap, value::String)::MaxHeap
    push!(heap.tree, value)
    sift_up!(last_node(heap.tree))
    return heap
end

function Base.pop!(heap::MaxHeap)::String
    ret_val = pop!(heap.tree)
    heap.tree.root !== nothing && sift_down!(heap.tree.root)
    return ret_val
end

function Base.show(io::IO, tree::BalancedBinaryTree{T}) where {T}
    print(io, "$(tree.num_nodes)-element BalancedBinaryTree{$T}")
    if tree.num_nodes > 0
        show_node(io, tree.root)
    end
end

end  # module