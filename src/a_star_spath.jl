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

function a_star_impl!{V,D,DH}(
    graph::AbstractGraph{V},# the graph
    frontier,               # an initialized heap containing the active vertices
    colormap::AbstractVertexColormap{Int},  # an (initialized) color-map to indicate status of vertices
    edge_dists::AbstractEdgePropertyInspector{D},  # cost of each edge
    heuristic::AbstractVertexPropertyInspector{DH},    # heuristic fn (under)estimating distance to target
    t::V)  # the end vertex

    while !isempty(frontier)
        (cost_so_far, path, u) = dequeue!(frontier)
        if u == t
            return path
        end

        for edge in out_edges(u, graph)
            v = target(edge)
            if colormap[v,graph] < 2
                colormap[v,graph] = 1
                new_path = cat(1, path, edge)
                path_cost = cost_so_far + edge_property(edge_dists, edge, graph)
                enqueue!(frontier,
                        (path_cost, new_path, v),
                        path_cost + vertex_property(heuristic,v, graph))
            end
        end
        colormap[u,graph] = 2
    end
    nothing
end


function shortest_path{V,E,D,DH}(
    graph::AbstractGraph{V,E},  # the graph
    edge_dists::AbstractEdgePropertyInspector{D},      # cost of each edge
    s::V,                       # the start vertex
    t::V,                       # the end vertex
    heuristic::AbstractVertexPropertyInspector{DH} = ConstantVertexPropertyInspector(0))

            # heuristic (under)estimating distance to target
    frontier = PriorityQueue{(D,Array{E,1},V),D}()
    frontier[(zero(D), E[], s)] = zero(D)
    if implements_vertex_map(graph)
        colormap = VectorVertexColormap{Int}(zeros(Int, num_vertices(graph)))
    else
        colormap = HashVertexColormap{Int}(Dict{V,Int}())
    end
    colormap[s,graph] = 1
    a_star_impl!(graph, frontier, colormap, edge_dists, heuristic, t)
end

function shortest_path{V,E,D}(
    graph::AbstractGraph{V,E},  # the graph
    edge_dists::Vector{D},      # cost of each edge
    s::V,                       # the start vertex
    t::V,                       # the end vertex
    fheuristic::Function = n -> 0)
    edge_len::AbstractEdgePropertyInspector{D} = VectorEdgePropertyInspector(edge_dists)

    heuristic = FunctionVertexPropertyInspector{D}(fheuristic)
    shortest_path(graph, edge_len, s, t, heuristic)
end


end

using .AStar
