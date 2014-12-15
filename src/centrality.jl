function _degree_centrality{V}(g::AbstractGraph{V}, gtype::Integer; normalize=true)
   c = Dict{V,Float64}()
   for v in vertices(g)
       if gtype == 0    # count both in and out degree if appropriate
           deg = out_degree(v,g) + (is_directed(g)? in_degree(v,g) : 0)
       elseif gtype == 1    # count only in degree
           deg = in_degree(v,g)
       else                 # count only out degree
           deg = out_degree(v,g)
       end
       if normalize
           nv = num_vertices(g)
           s = 1.0 / (nv - 1.0)
       else
           s = 1.0
       end

       c[v] = deg*s
   end
   return c
end

degree_centrality(g; all...) = _degree_centrality(g, 0; all...)
in_degree_centrality(g; all...) = _degree_centrality(g, 1; all...)
out_degree_centrality(g; all...) = _degree_centrality(g, 2; all...)


############################################################################
#
# Note: Functions below this comment block are derived in part from the
# NetworkX Python library and are BSD Licensed as follows:
#
# Copyright (C) 2004-2012, NetworkX Developers
# Aric Hagberg <hagberg@lanl.gov>
# Dan Schult <dschult@colgate.edu>
# Pieter Swart <swart@lanl.gov>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#   * Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#
#   * Redistributions in binary form must reproduce the above
#     copyright notice, this list of conditions and the following
#     disclaimer in the documentation and/or other materials provided
#     with the distribution.
#
#   * Neither the name of the NetworkX Developers nor the names of its
#     contributors may be used to endorse or promote products derived
#     from this software without specific prior written permission.
#
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
############################################################################
