function min_st_cut{V,E}(g::AbstractGraph{V,E},s::V,t::V,capacity::Vector{Float64})
  @graph_requires g incidence_list vertex_list
  @assert is_directed(g)

  r = residual_graph(g,s,capacity)
  flow = edmonds_karp_max_flow!(r,s,t)
  parity = dfs(r,s)
  return parity, flow
end

function max_flow{V,E}(g::AbstractGraph{V,E},s::V,t::V,capacity::Vector{Float64})
  @graph_requires g incidence_list vertex_list
  @assert is_directed(g)

  r = residual_graph(g,s,capacity)
  return edmonds_karp_max_flow!(r,s,t)
end

function residual_graph{V,E}(g::AbstractGraph{V,E},s::V,capacity::Vector{Float64})
  visited = fill(false,num_vertices(g))
  res_g = inclist(vertices(g),ExEdge{V},is_directed=true)
  residual_graph_sub!(g,res_g,s,visited,capacity)
  return res_g
end

function residual_graph_sub!{V,E1,E2}(g::AbstractGraph{V,E1},r::AbstractGraph{V,E2},
                                      s::V, visited::Vector{Bool}, capacity::Vector{Float64})
  visited[vertex_index(s,g)] = true
  for edge in out_edges(s,g)
    i = edge_index(edge); u = edge.source; v = edge.target
    d1 = Dict{UTF8String,Any}(); d1["capacity"] = capacity[i]; d1["flow"] = 0
    d2 = Dict{UTF8String,Any}(); d2["capacity"] = capacity[i]; d2["flow"] = capacity[i]
    edge     = ExEdge(i, u, v, d1)
    rev_edge = ExEdge(i, v, u, d2)
    add_edge!(r,edge)
    add_edge!(r,rev_edge)
    if !visited[vertex_index(v,g)]
      residual_graph_sub!(g,r,v,visited,capacity)
    end
  end
end

function edmonds_karp_max_flow!{V,E}(g::AbstractGraph{V,E},s::V,t::V)
  flow = 0

  while true

    #run BFS to find shortest s-t path
    #store edges taken to get to each vertex in 'pred'
    pred = bfs(g,s,t)

    #stop if we weren't able to find a path from s to t
    if !haskey(pred,t)
      break
    end

    #Otherwise see how much flow we can send
    df = Inf
    edge = pred[t]
    while true
      df = min(df, edge.attributes["capacity"] - edge.attributes["flow"])
      if haskey(pred,edge.source) 
        edge = pred[edge.source]
      else
        break
      end
    end

    #and update edges by that amount
    edge = pred[t]
    while true
      #find rev edge
      t_edges = out_edges(edge.target,g)
      idx = find(x-> x.target==edge.source,t_edges) #there should be only one!
      rev_edge = t_edges[idx[1]]

      edge.attributes["flow"] += df
      rev_edge.attributes["flow"] -= df

      if haskey(pred,edge.source) 
        edge = pred[edge.source]
      else
        break
      end
    end
    flow += df
  end
  return flow
end

function bfs{V,E}(g::AbstractGraph{V,E},s::V,t::V)
  q = DataStructures.Queue(V)
  enqueue!(q,s)

  pred = Dict{V,E}()

  while length(q) > 0
    cur = dequeue!(q)
    for edge in out_edges(cur,g)
      if !haskey(pred,edge.target) && edge.target != s && edge.attributes["capacity"] > edge.attributes["flow"]
        pred[edge.target] = edge
        enqueue!(q,edge.target)
      end
    end
  end
  return pred
end

function dfs{V,E}(g::AbstractGraph{V,E},s::V)
  colormap = fill(false,num_vertices(g))
  return dfs!(g,s,colormap)
end

function dfs!{V,E}(g::AbstractGraph{V,E},s::V, colormap::Vector{Bool})
  colormap[vertex_index(s,g)] = true
  for edge in out_edges(s,g)
    if edge.attributes["capacity"] > edge.attributes["flow"] && !colormap[vertex_index(edge.target,g)]
      dfs!(g,edge.target,colormap)
    end
  end
  return colormap
end
