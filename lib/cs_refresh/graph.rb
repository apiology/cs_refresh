require 'priority_queue'

module CsRefresh
  # Describes an edge between graph nodes
  class GraphEdge
    attr_reader :weight, :target
    def initialize(weight, target)
      @weight = weight
      @target = target
    end
  end

  # Describes a graph node
  class AdjacencyListGraph
    attr_reader :value
    attr_reader :edges

    def initialize(value = nil)
      @value = value
      @edges = []
    end

    def link_to!(node, weight = 1)
      @edges << GraphEdge.new(weight, node)
    end

    def undirected_link_to!(node, weight = 1)
      link_to!(node, weight)
      node.link_to!(self, weight)
    end

    def link(node)
      @edges.find { |edge| edge.target == node }
    end

    def to_s
      "node<#{value}>"
    end

    def inspect
      to_s
    end

    # Implement's Djikstra's algorithm
    def shortest_paths
      Dijkstra.new(self).shortest_paths
    end

    # Performs Dijkstra's algorithm on the specified graph starting
    # node
    class Dijkstra
      def initialize(start)
        @distance = {}
        @prev = {}
        @distance_minimized = Set.new
        @prev[start] = nil

        @closest = PriorityQueue.new
        @closest.push(start, 0)

        dijkstraize!
      end

      def dijkstraize!
        # Invariants:
        #
        # Each vertice is in priority queue zero or one times.
        #
        # Min in priority queue is always the final shortest path for
        # that vertice.
        #
        until (node, node_distance = @closest.delete_min).nil?
          explore_node(node, node_distance)
        end
      end

      def shortest_paths
        @shortest_paths ||= @distance.keys.map do |node|
          [node, [@distance[node], format_path(path(node))]]
        end.to_h
      end

      def explore_node(node, node_distance)
        @distance[node] = node_distance
        @distance_minimized.add(node)

        node.edges.each do |edge|
          unless @distance_minimized.include?(edge.target)
            if relax(edge.target, @distance[node] + edge.weight)
              @prev[edge.target] = node
            end
          end
        end
      end

      def format_path(path)
        path[1..path.length - 2].reverse
      end

      def path(node)
        if node.nil?
          []
        else
          [node].concat(path(@prev[node]))
        end
      end

      def relax(node,
                new_distance)
        old_distance = @closest[node]
        if old_distance.nil? || old_distance > new_distance
          @closest[node] = new_distance
          true
        else
          false
        end
      end
    end

    def calc_max_distances
      # push all of the links from this node

      # :black => costs of all neighbors have been determined.
      # :grey => costs of self has been determined
      color = {}
      cost = {}
      # min_heap = min_heap.new
      queue = []
      queue.push(self)
      cost[self] = 0
      until (item = queue.shift).nil?
        unless color[item] == :black
          color[item] = :black
          item.edges.each do |link|
            unless color[link.target]
              cost[link.target] = cost[item] + 1
              color[link.target] = :grey
              queue.push(link.target)
            end
          end
        end
      end
      cost
    end

    def find_nodes_dfs
      GraphDepthFirstSearch.new(self).all_nodes
    end

    # Does a DFS on a graph node
    class GraphDepthFirstSearch
      attr_reader :all_nodes

      def initialize(root_node)
        @root_node = root_node
        @all_nodes = Set.new
        @color = {}
        search(root_node)
      end

      def search(node)
        node.edges.each do |link|
          unless @color[link.target]
            all_nodes << link.target
            @color[link.target] = :grey
            search(link.target)
          end
        end
        @color[node] = :black
      end
    end
  end
end
