using Graphs
using Base.Test

#example from wikipedia

g = inclist(collect(1:7),is_directed=true)

#(u, v, c) edge from u to v with capacity c
inputs = [
(1, 2, 3.),
(1, 4, 3.),
(2, 3, 4.),
(3, 1, 3.),
(3, 4, 1.),
(3, 5, 2.),
(4, 5, 2.),
(4, 6, 6.),
(5, 2, 1.),
(5, 7, 1.),
(6, 7, 9.)]


m = length(inputs)
c = zeros(m)
for i = 1 : m
  add_edge!(g, inputs[i][1],inputs[i][2])
  c[i] = inputs[i][3]
end

@assert num_vertices(g) == 7
@assert num_edges(g) == 11

parity, f = min_st_cut(g,1,7,c)

@test length(parity) == 7
@test parity == Bool[true,true,true,false,true,false,false]
@test f == 5.0

f = max_flow(g,1,7,c)
@test f == 5.0
