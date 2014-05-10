# -*- coding: utf-8 -*-
require 'spec_helper'
require 'cs_refresh'


def test_simple_graph(graph_class)
  describe "simple graph" do
    node1 = graph_class.new(5)
    node2 = graph_class.new("spaghetti")
    node1.link_to!(node2, 3)
    it "Should have weights set" do
      expect(node1.link(node2).weight).to eq 3
    end
  end
end

def test_complex_graph(graph_class)
  # 23.1-1
  #
  # Calculating each out_degree would cost O(V), as it would be an
  # O(1) operation to ask the length of each adjacency list.
  #
  # Calculating each in_degree would require stepping through each
  # edge.  O(E).
  #
  #
  describe "complex graph" do
    r = graph_class.new('r')
    s = graph_class.new('s')
    t = graph_class.new('t')
    u = graph_class.new('u')
    v = graph_class.new('v')
    w = graph_class.new('w')
    x = graph_class.new('x')
    y = graph_class.new('y')
    z = graph_class.new('z')

    r.undirected_link_to!(s, 2)
    r.undirected_link_to!(v, 3)
    s.undirected_link_to!(w, 5)
    w.undirected_link_to!(t, 1)
    w.undirected_link_to!(x, 9)
    t.undirected_link_to!(x, 2)
    t.undirected_link_to!(u, 7)
    x.undirected_link_to!(y, 1)
    u.undirected_link_to!(y, 3)

    it "Should do a BFS" do
      max_distances = {
        v => 2, r => 1, s => 0, w => 1,
        t => 2, x => 2, u => 3, y => 3
      }
      expect(s.calc_max_distances).to eq max_distances
    end

    it "Should do a DFS" do
      all_nodes = [r, s, t, u, v, w, x, y].to_set
      expect(s.find_nodes_dfs).to eq all_nodes
    end

    it "Should do Djisktra's algorithm" do
      result = {
        r => [2, []],
        s => [0, []],
        t => [6, [w]],
        u => [12, [w, t, x, y]],
        v => [5, [r]],
        w => [5, []],
        x => [8, [w, t]],
        y => [9, [w, t, x]]
      }
      expect(s.shortest_paths).to eq result
    end
  end
end

def test(graph_class)
  describe graph_class do
    test_simple_graph(graph_class)
    test_complex_graph(graph_class)
  end
end


# # NEXT: Array-based tree storage?
[CsRefresh::AdjacencyListGraph].each do |graph_class|
  test(graph_class)
end
