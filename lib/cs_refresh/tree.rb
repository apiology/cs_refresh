# Code to refresh my memory of algorithms and data structures
module CsRefresh
  # My implementation of a binary tree with various traversals.
  class BinaryTree
    attr_accessor :element, :parent
    attr_reader :left, :right

    def left=(node)
      # puts "Assigning left of #{element} as #{node.element}"
      @left.parent = nil unless @left.nil?
      node.parent = self unless node.nil?
      @left = node
    end

    def right=(node)
      # if node.nil?
      #   puts "Assigning right of #{element} as nil"
      # else
      #   puts "Assigning right of #{element} as #{node.element}"
      # end
      @right.parent = nil unless @right.nil?
      node.parent = self unless node.nil?
      @right = node
    end

    def initialize(element, left = nil, right = nil)
      @element = element
      @left = left
      @right = right
    end

    def root
      ret = if parent.nil?
              self
            else
              parent.root
            end
      # puts "Root is #{ret}"
      ret
    end

    def simple_paths
      child_paths(left).concat(child_paths(right))
    end

    def child_paths(child)
      if child.nil?
        [[element]]
      else
        child.simple_paths.map { |path| [element].concat(path) }
      end
    end

    def left_to_str(num_indents)
      left_str = ''
      left_str = left.to_s(num_indents + 2) unless left.nil?
      left_str
    end

    def right_to_str(num_indents)
      right_str = ''
      right_str = right.to_s(num_indents + 2) unless right.nil?
      right_str
    end

    def to_s(num_indents = 0)
      left_str = left_to_str(num_indents)
      spaces = ''
      num_indents.times { spaces += ' ' }
      ele_str = "#{spaces}<treenode: #{element}>\n"
      right_str = right_to_str(num_indents)
      "#{right_str}#{ele_str}#{left_str}"
    end

    def left_rotate!
      old_right = right
      old_right_left = right.left
      parent.replace(self, right) unless parent.nil?
      old_right.left = self
      @right = old_right_left
    end

    def right_rotate!
      old_left = left
      old_left_right = left.right
      parent.replace(self, left) unless parent.nil?
      old_left.right = self
      @left = old_left_right
    end

    def replace(tree, new_tree)
      if @left == tree
        # puts "Left was the tree!"
        self.left = new_tree
      else
        # puts "Right was the tree!"
        self.right = new_tree
      end
    end

    def walk(&proc)
      left.walk(&proc) unless left.nil?
      yield self
      right.walk(&proc) unless right.nil?
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

    # State of graph visiting
    class VisitState
      attr_accessor :visited_left, :visited_right, :node

      def initialize(node)
        @node = node
      end
    end

    def dfs_post_order_iterative
      PostOrderTreeIterator.new(self).out
    end

    # Iterates through trees in a post-order fashion without recursion.
    class PostOrderTreeIterator
      attr_reader :out

      def initialize(node)
        @current = VisitState.new(node)
        @visit_next = []
        @out = []
        iterate! until @current.nil?
      end

      def iterate!
        if @current.node.left && !@current.visited_left
          iterate_left!
        elsif @current.node.right && !@current.visited_right
          iterate_right!
        else
          iterate_up!
        end
      end

      def iterate_left!
        @current.visited_left = true
        @visit_next.push(@current)
        @current = VisitState.new(@current.node.left)
      end

      def iterate_right!
        @current.visited_right = true
        @visit_next.push(@current)
        @current = VisitState.new(@current.node.right)
      end

      def iterate_up!
        @out << @current.node.element
        @current = @visit_next.pop
      end
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
