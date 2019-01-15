module PointerBasedTrees

# using AbstractTrees
using FMMTrees

mutable struct Node{T}
    data::T
    num_children::Int
    next_sibling::Int
    parent::Int
    first_child::Int
end

struct PointerBasedTree{N<:Node}
    nodes::Vector{N}
    root::Int
end

FMMTrees.root(tree::PointerBasedTree) = tree.nodes[tree.root]

struct ChildView{T,N}
    tree::T
    node::N
end

function Base.iterate(itr::ChildView)
    itr.node.first_child < 1 && return iterate(itr, nothing)
    iterate(itr, itr.tree.nodes[itr.node.first_child])
end

function Base.iterate(itr::ChildView, state)
    state == nothing && return nothing
    state.next_sibling < 1 && return (state, nothing)
    return state, itr.tree.nodes[state.next_sibling]
end

Base.IteratorSize(cv::ChildView) = Base.SizeUnknown()
FMMTrees.children(tree::PointerBasedTree, node=FMMTrees.root(tree)::Node) = collect(ChildView(tree, node))

# start(cv::ChildView) = (cv.tree.nodes[cv.tree.root].first_child)
# done(cv::ChildView, idx) = (idx == -1)
# function next(cv::ChildView, idx)
#     value = PointerBasedTree(cv.tree.nodes, idx)
#     idx = cv.tree.nodes[idx].next_sibling
#     return value, idx
# end
#
# Base.iterate(cv::ChildView, s=start(cv)) = done(cv,s) ? nothing : next(cv,s)

FMMTrees.data(tree::PointerBasedTree, node=FMMTrees.root(tree)) = node.data
# AbstractTrees.printnode(io::IO, tree::PointerBasedTree) = show(io, data(tree))


function insert_child!(tree::PointerBasedTree, parent_idx, data)
    parn = tree.nodes[parent_idx]
    node = FMMTrees.PointerBasedTrees.Node(data, 0, parn.first_child, parent_idx, 0)
    push!(tree.nodes, node)
    parn.first_child = length(tree.nodes)
end


end # module PointerBasedTrees
