type HashUndirectedGraph{V,E} <: AbstractGraph{V,E}
    adj::Dict{V,Dict{V, E}} # u -> v -> edge(u,v)
    edges::Dict{E,(V,V)}    # edge -> (source, target)
}

@graph_implements HashUndirectedGraph vertex_list edge_list
@graph_implements HashUndirectedGraph bidirectional_adjacency_list bidirectional_incidence_list

source{V,E}(e::E, g::HashUndirectedGraph{V,E}) = g.edges[e][1]
target{V,E}(e::E, g::HashUndirectedGraph{V,E}) = g.edges[e][2]


is_directed(g::HashUndirectedGraph) = false

num_vertices(g::HashUndirectedGraph) = length(g.adj)
vertices(g::HashUndirectedGraph) = keys(g.adj)

num_edges(g::HashUndirectedGraph) = length(g.edges)
edges(g::HashUndirectedGraph) = keys(g.edges)

out_edges{V}(v::V, g::HashUndirectedGraph{V}) = values(g.adj[v])
out_degree{V}(v::V, g::HashUndirectedGraph{V}) = length(g.adj[v])
out_neighbors{V}(v::V, g::HashUndirectedGraph{V}) = keys(g.adj[v])

in_edges{V}(v::V, g::HashUndirectedGraph{V}) = values(g.adj[v])
in_degree{V}(v::V, g::HashUndirectedGraph{V}) = length(g.adj[v])
in_neighbors{V}(v::V, g::HashUndirectedGraph{V}) = keys(g.adj[v])

has_vertex{V}(v::V, g::HashUndirectedGraph{V}) = haskey(g.adj,v)
has_edge{V,E}(e::E, g::HashUndirectedGraph{V,E}) = haskey(g.edges,e)
function has_edge_between(u::V, v::V, , g::HashUndirectedGraph{V}) = haskey(g.adj[u], v)

function add_vertex!{V,E}(g::HashUndirectedGraph{V,E}, v::V)
    if !haskey(g.adj, v)
        g.adj[v]=Dict{V,E}()
    end
end

function delete_vertex!{V}(g::HashUndirectedGraph{V}, v::V)
    if haskey(g.adj,v)
        for u,e in g.adj[v]
            delete!(g.adj[u], v)
            delete!(g.edges, e)
        end
    end
end

function add_edge!{V,E}(g::HashUndirectedGraph{V,E}, e::E, u::V, v::V)
    if haskey(g.edges, e) 
        if !(g.edges[e] == (u,v) || g.edges[e] == (v,u))
            #yank out the old edge
            u1,v1 = g.edges[e]
            delete!(g.adj[u1], v1)
            delete!(g.adv[v1], u1)
        else
            return g
        end
    end
    g.adj[u][v] = e
    g.adj[v][u] = e
    g.edges[e] = (u,v)
    g
end

function delete_edge!{V,E}(e:E, g::HashUndirectedGraph{V,E})
    if haskey(g.edges, e)
        u,v = g.edges[e]
        delete!(g.adj[u],v)
        delete!(g.adj[v],u)
        delete!(g.edges, e)
    end
end
