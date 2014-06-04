# A* shortest-path algorithm

#################################################
#
#  A* shortest-path algorithm
#
#################################################

module AStar

# The enqueue! and dequeue! methods defined in Base.Collections (needed for
# PriorityQueues) conflict with those used for queues. Hence we wrap the A*
# code in its own module.

using Graphs
using Base.Collections

export shortest_path

function a_star_impl!{V}(
    graph::AbstractGraph{V},# the graph
    frontier,               # an initialized heap containing the active vertices
    colormap::Vector{Int},  # an (initialized) color-map to indicate status of vertices
    edge_dists,  # cost of each edge
    heuristic,    # heuristic fn (under)estimating distance to target
    t::V)  # the end vertex

    while !isempty(frontier)
        (cost_so_far, path, u) = dequeue!(frontier)
        if u == t
            return path
        end
    
        for edge in out_edges(u, graph)
            v = target(edge)
            if colormap[vertex_index(v,graph)] < 2
                colormap[vertex_index(v,graph)] = 1
                new_path = cat(1, path, edge)
                path_cost = cost_so_far + edge_property(edge_dists, edge, graph)
                enqueue!(frontier,
                        (path_cost, new_path, v),
                        path_cost + vertex_property(heuristic,v, graph))
            end
        end
        colormap[vertex_index(u,graph)] = 2
    end
    nothing
end


function shortest_path{V,E}(
    graph::AbstractGraph{V,E},  # the graph
    edge_dists,                 # cost of each edge
    s::V,                       # the start vertex
    t::V,                       # the end vertex
    heuristic=0)

    # heuristic (under)estimating distance to target
    D = edge_property_type(edge_dists, graph)
    frontier = PriorityQueue{(D,Array{E,1},V),D}()
    frontier[(zero(D), E[], s)] = zero(D)
    colormap = zeros(Int, num_vertices(graph))
    colormap[vertex_index(s,graph)] = 1
    a_star_impl!(graph, frontier, colormap, edge_dists, heuristic, t)
end

end

using .AStar
