Vertices and Edges
===================

Vertex Types
-------------

A vertex can be of any Julia type. For example, it can be an integer, a character, or a string. In a simplistic setting where there is no additional information associated with a vertex, it is recommended to use ``Int`` as the vertex type, which would lead to the best performance.

This package provides two specific vertex types: ``KeyVertex`` and ``ExVertex``. The definition of ``KeyVertex`` is:

.. code-block:: python

    immutable KeyVertex{K}
        index::Int
        key::K
    end

Here, each vertex has a unique index and a key value of a user-chosen type (*e.g.* a string).

The definition of ``ExVertex`` is:

.. code-block:: python

    type ExVertex
        index::Int
        label::UTF8String
        attributes::Dict{UTF8String,Any}
    end

The ``ExVertex`` type allows one to attach a label as well as other attributes to a vertex. The constructor of this type takes an index and a label string as arguments. The following code shows how one can create an instance of ``ExVertex`` and attach a price to it.

.. code-block:: python

    v = ExVertex(1, "vertex-a")
    v.attributes["price"] = 100.0

The ``ExVertex`` type implements a ``vertex_index`` function, as

.. py:function:: vertex_index(v)

    returns the index of the vertex ``v``.

In addition, for integers, we have

.. code-block:: python

    vertex_index(v::Integer) = v

This makes it convenient to use integers as vertices in graphs.


Edge Types
-----------

This package provides two edge types: ``Edge`` and ``ExEdge``. The former is a basic edge type that simply encapsulates the source and target vertices of an edge, while the latter allows one to specify attributes.

The definition of ``Edge`` is given by

.. code-block:: python

    immutable Edge{V}
        index::Int
        source::V
        target::V
    end

    typealias IEdge Edge{Int}

The definition of ``ExEdge`` is given by

.. code-block:: python

    type ExEdge{V}
        index::Int
        source::V
        target::V
        attributes::Dict{UTF8String,Any}
    end

``ExEdge`` has two constructors, one takes ``index``, ``source``, and ``target`` as arguments, while the other use all four fields.

One can either construct an edge directly using the constructors, or use the ``add_edge`` methods for graphs, which can automatically assign an index to a new edge.

Both edge types implement the following methods:

.. py:function:: edge_index(e)

    returns the index of the edge ``e``.

.. py:function:: source(e)

    returns the source vertex of the edge ``e``.

.. py:function:: target(e)

    returns the target vertex of the edge ``e``.

.. py::function:: revedge(e)

    returns a new edge, exactly the same except source and target are switched.

A custom edge type ``E{V}`` which is constructible by ``E(index::Int, s::V, t::V)`` and implements the above methods is usable in the ``VectorIncidenceList`` parametric type.  Construct such a list with ``inclist(V,E{V})``, where E and V are your vertex and edge types.  See test/inclist.jl for an example.

Vertex Properties
---------------

Many algorithms use a property of a vertex such as amount of a
resource provided or required by that vertex as input. As the
algorithms do not mandate any structure for the vertex types, these
vertex properties can be passed through to the algorithm by an
``VertexPropertyInspector``.  An ``VertexPropertyInspector`` when
passed to the ``vertex_property`` method along with a vertex and a
graph, will return that property of a vertex.

All vertex property inspectors should be declared as a subtype of
``AbstractVertexPropertyInspector{T}`` where ``T`` is the type of the
vertex property.  The vertex propery inspector should respond to the
following methods.

.. py::function:: vertex_property(i, e, g)

  returns the vertex property of vertex ``v`` in graph ``g`` selected by
  inspector ``i``.

.. py::function:: vertex_property_requirement(i, g)

  checks that graph ``g`` implements the interface(s) necessary for
  inspector ``i``

Three vertex property inspectors are provided
``ConstantVertexPropertyInspector``, ``VectorVertexPropertyInspector`` and
``AttributeVertexPropertyInspector``.

``ConstantVertexPropertyInspector(c)`` constructs a vertex property
inspector that returns the constant ``c`` for each vertex.

``VectorVertexPropertyInspector(vec)`` constructs a vertex property
inspector that returns ``vec[vertex_index(v, g)]``.  It requires that
``g`` implement the ``vertex_map`` interface.

``FunctionVertexPropertyInspector(func)``  constructs a vertex property
inspector that returns the result of ``func(v)`` from an ``ExVertex``.
``AttributeVertexPropertyInspector`` requires that the graph implements
the ``vertex_map`` interface.



Edge Properties
---------------

Many algorithms use a property of an edge such as length, weight,
flow, etc. as input. As the algorithms do not mandate any structure
for the edge types, these edge properties can be passed through to the
algorithm by an ``EdgePropertyInspector``.  An
``EdgePropertyInspector`` when passed to the ``edge_property`` method
along with an edge and a graph, will return that property of an edge.

All edge property inspectors should be declared as a subtype of
``AbstractEdgePropertyInspector{T}`` where ``T`` is the type of the
edge property.  The edge propery inspector should respond to the
following methods.

.. py::function:: edge_property(i, e, g)

  returns the edge property of edge ``e`` in graph ``g`` selected by
  inspector ``i``.

.. py::function:: edge_property_requirement(i, g)

  checks that graph ``g`` implements the interface(s) necessary for
  inspector ``i``

Three edge property inspectors are provided
``ConstantEdgePropertyInspector``, ``VectorEdgePropertyInspector`` and
``AttributeEdgePropertyInspector``.

``ConstantEdgePropertyInspector(c)`` constructs an edge property
inspector that returns the constant ``c`` for each edge.

``VectorEdgePropertyInspector(v)`` constructs an edge property
inspector that returns ``v[edge_index(e, g)]``.  It requires that
``g`` implement the ``edge_map`` interface.

``AttributeEdgePropertyInspector(name)``  constructs an edge property
inspector that returns the named attribute from an ``ExEdge``.
``AttributeEdgePropertyInspector`` requires that the graph implements
the ``edge_map`` interface.
