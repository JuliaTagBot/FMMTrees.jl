module SimpleTrees

using AbstractTrees
using FMMTrees

struct TreeNode{T}
    num_children::Int
    data::T
end

struct SimpleTree{V <: (AbstractVector{N} where {N<:TreeNode})}
    nodes::V
end


struct ChildView{T} tree::T end
AbstractTrees.children(tree::SimpleTree) = collect(ChildView(tree))

Base.IteratorSize(cv::ChildView) = Base.SizeUnknown()
start(itr::ChildView{T} where {T<:SimpleTree}) = (0, 2) # progress, relative_index
function done(itr::ChildView{T} where {T<:SimpleTree}, state)
    return (state[1] == first(itr.tree.nodes).num_children)
end
function next(itr::ChildView{T} where {T<:SimpleTree}, state)
    child = itr.tree.nodes[state[2]]
    newstate = (state[1] + child.num_children + 1, state[2] + child.num_children + 1)
    return SimpleTree(view(itr.tree.nodes, state[2]:endof(itr.tree.nodes))), newstate
end

function Base.iterate(itr::ChildView, state=start(itr))
    done(itr, state) ? nothing : next(itr, state)
end

Base.getindex(tree::SimpleTree, i::Int) = tree.nodes[i]

FMMTrees.data(tree::SimpleTree) = first(tree.nodes).data
AbstractTrees.printnode(io::IO, tree::SimpleTree) = showcompact(io, data(tree))

end # module SimpleTrees
