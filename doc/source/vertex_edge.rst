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
resource provided or required by that vertex as input. These are
communicated to the code through the following methods:

.. py::function:: vertex_property(i, v, g)
Returns the property of vertex ``v`` in graph ``g``.

.. py::function:: vertex_property_requirement(i, g)
Checks that the graph ``g`` supports the interfaces necessary to 
access the vertex property.

.. py::function:: vertex_property_type(i, g)
Returns the type returned by ``vertex_property`` in graph ``g``.

In all of these ``i`` is a type that indicates how the property is to
be obtained, both by influencing whish method is chosen and providing
information to that method.  The following example implementations are provided:

``Number``:  If ``i`` is a ``Number`` then each vertex is given that
value.

``AbstractVector``:  If ``i`` is an ``AbstractVector`` then each
vertex ``v`` has value ``i[vertex_index(v,g)]``.

``UTF8String``:  If ``i`` is an ``UTF8String`` and ``v`` is an
``ExVertex`` then the the vertex has value ``v.attributes[i]``.

``Function``:  If ``i`` is a ``Function`` then ``v`` has value ``i(v)``.



Edge Properties
---------------


Many algorithms use a property of an edge such as length, weight,
flow, etc. as input. As the algorithms do not mandate any structure
for the edge types, these edge properties are
communicated to the code through the following methods (analogous to
the vertex meghods:

.. py::function:: edge_property(i, e, g)
Returns the property of edge ``e`` in graph ``g``.

.. py::function:: edge_property_requirement(i, g)
Checks that the graph ``g`` supports the interfaces necessary to 
access the edge property.

.. py::function:: vertex_property_type(i, g)
Returns the type returned by ``edge_property`` in graph ``g``.

In all of these ``i`` is a type that indicates how the property is to
be obtained, both by influencing whish method is chosen and providing
information to that method.  The following example implementations are provided:

``Number``:  If ``i`` is a ``Number`` then each edge is given that
value.

``AbstractVector``:  If ``i`` is an ``AbstractVector`` then each
edge ``e`` has value ``i[vertex_index(e,g)]``.

``UTF8String``:  If ``i`` is an ``UTF8String`` and ``e`` is an
``ExEdge`` then the the vertex has value ``e.attributes[i]``.

``Function``:  If ``i`` is a ``Function`` then ``e`` has value ``i(e)``.
