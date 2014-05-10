module CsRefresh
  # Performs AStar algorithm on the specified graph starting
  # node
  class AStar
    def initialize(start, goal, estimates_to_finish)
      @goal = goal
      @remaining_path_estimate = estimates_to_finish
      @distance_from_start = { start => 0 }
      @estimated_cost_through_this_node = {}
      @estimated_cost_through_this_node[start] =
        0 + @remaining_path_estimate[start]
      @closed_set = Set.new

      @prev = {}
      @prev[start] = nil

      @closest = PriorityQueue.new
      @closest.push(start,
                    @estimated_cost_through_this_node[start])

      astar!
    end

    def astar!
      # Invariants:
      #
      # Each vertice is in priority queue zero or one times.
      #
      # Min in priority queue is always the final shortest path for
      # that vertice.
      #
      until (node, estimated_total_distance = @closest.delete_min).nil?
        break if explore_node(node, estimated_total_distance)
      end
    end

    def explore_node(node, estimated_total_distance)
      @closed_set.add(node)
      return true if node == @goal
      node.edges.each do |edge|
        unless @closed_set.include?(edge.target)
          tentative_distance_from_start =
            @distance_from_start[node] + edge.weight
          if relax(edge.target, tentative_distance_from_start)
            @prev[edge.target] = node
          end
        end
      end
      false # didn't find end
    end

    def best_path
      path(@goal).reverse[1..-1]
    end

    def path(node)
      if node.nil?
        []
      else
        [node].concat(path(@prev[node]))
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

    def relax(node, new_distance)
      old_distance = @distance_from_start[node]
      if old_distance.nil? || old_distance > new_distance
        @distance_from_start[node] = new_distance
        @estimated_cost_through_this_node[node] =
          @distance_from_start[node] +
          @remaining_path_estimate[node]
        @closest[node] = @estimated_cost_through_this_node[node]
        true
      else
        false
      end
    end
  end
end
