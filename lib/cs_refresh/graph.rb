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
  end
end
