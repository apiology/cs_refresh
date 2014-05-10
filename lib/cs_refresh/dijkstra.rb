module CsRefresh
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
end
