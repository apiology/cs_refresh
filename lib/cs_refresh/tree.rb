# Code to refresh my memory of algorithms and data structures
module CsRefresh
  # My implementation of a binary tree with various traversals.
  class BinaryTree
    attr_reader :element, :left, :right

    def initialize(element, left = nil, right = nil)
      @element = element
      @left = left
      @right = right
    end

    def dfs_pre_order
      out = []
      out << element
      out.concat left.dfs_pre_order unless left.nil?
      out.concat right.dfs_pre_order unless right.nil?
      out
    end

    def dfs_pre_order_iterative
      out = []
      work = [self]

      until work.empty?
        node = work.pop
        out << node.element
        work.push node.right unless node.right.nil?
        work.push node.left unless node.left.nil?
      end

      out
    end

    def dfs_in_order_iterative
      InOrderTreeIterator.new(self).out
    end

    # Iterate through a Tree in-order.
    class InOrderTreeIterator
      attr_reader :out

      def initialize(current_)
        @current = current_
        @visit_self_then_right = []
        @out = []
        iterate!
      end

      def visit_current
        @visit_self_then_right.push @current
        if @current.left.nil?
          @current = nil
        else
          @current = @current.left
        end
      end

      def visit_next
        e = @visit_self_then_right.pop
        @out << e.element
        @current = e.right
      end

      def iterate!
        while @current || !@visit_self_then_right.empty?
          if @current
            visit_current
          else
            visit_next
          end
        end
      end
    end

    def dfs_in_order
      out = []
      out.concat left.dfs_in_order unless left.nil?
      out << element
      out.concat right.dfs_in_order unless right.nil?
      out
    end

    def dfs_post_order
      out = []
      out.concat left.dfs_post_order unless left.nil?
      out.concat right.dfs_post_order unless right.nil?
      out << element
      out
    end

    def bfs
      BreadthFirstSearcher.new(self).bfs
    end

    # Class that searches nodes in a breadth-first way
    class BreadthFirstSearcher
      attr_reader :bfs

      def initialize(top)
        @out = []
        @this_level = []
        @next_level = [top]
        @bfs = []

        traverse!
      end

      def traverse!
        loop do
          @this_level = @next_level
          @next_level = []
          # add this level until empty
          @this_level.each do |node|
            traverse_node!(node)
          end
          break if @next_level.empty?
        end
      end

      def traverse_node!(node)
        @bfs << node.element
        @next_level << node.left unless node.left.nil?
        @next_level << node.right unless node.right.nil?
      end
    end
  end
end
