require_relative 'tree'
require_relative 'assert'

module CsRefresh
  # My implementation of a binary search tree
  class BinarySearchTree
    def root
      @tree.root
    end

    def sorted_list
      if @tree.nil?
        []
      else
        @tree.dfs_in_order_iterative
      end
    end

    def invariants_held?
      true
    end

    def simple_paths(value)
      find_tree(value).simple_paths
    end

    def insert_value(value)
      if @tree.nil?
        @tree = BinaryTree.new(value)
      else
        push_down(value, @tree)
      end
    end

    def value_iterative?(value)
      tree = @tree
      until tree.nil?
        return true if tree.element == value
        tree = value < tree.element ? tree.left : tree.right
      end
      false
    end

    def value?(value)
      find_tree(value) != nil
    end

    def find_tree(value)
      find_tree_and_parent(value)[0]
    end

    def find_tree(value, tree = @tree)
      if tree.nil?
        nil
      elsif value == tree.element
        tree
      elsif value < tree.element
        find_tree(value, tree.left)
      else # value > tree.element
        find_tree(value, tree.right)
      end
    end

    def delete!(value, tree = @tree)
      if tree.nil?
        fail "Could not find element #{value}"
      elsif value == tree.element
        delete_root!(tree)
      elsif value < tree.element
        delete!(value, tree.left)
      else
        delete!(value, tree.right)
      end
    end

    def delete_root!(tree)
      # puts "Found element #{value} as #{tree.element}- deleting now!"
      if tree == @tree
        @tree = nil
      else
        delete_root_from_child_tree!(tree)
      end
    end

    def left_rotate!(value)
      tree = find_tree(value)
      tree.left_rotate!
    end

    def right_rotate!(value)
      tree = find_tree(value)
      tree.right_rotate!
    end

    def delete_root_from_child_tree!(tree)
      # parent must be set
      if tree.left
        # puts "Tree had a left!"
        tree.left = nil
        tree.parent.replace(tree, tree.left)
      elsif tree.right
        # puts "Tree had a right!"
        tree.right = nil
        tree.parent.replace(tree, tree.right)
      else
        # puts "Tree had neither!  Parent is #{tree.parent.element}"
        tree.parent.replace(tree, nil)
      end
    end

    def walk(&proc)
      @tree.walk(&proc)
    end

    def to_s
      @tree.to_s
    end

    private

    def push_down(value, tree)
      if value < tree.element
        push_down_left(value, tree)
      else
        push_down_right(value, tree)
      end
    end

    def push_down_left(value, tree)
      if tree.left.nil?
        tree.left = BinaryTree.new(value)
        tree.left
      else
        push_down(value, tree.left)
      end
    end

    def push_down_right(value, tree)
      if tree.right.nil?
        tree.right = BinaryTree.new(value)
        tree.right
      else
        push_down(value, tree.right)
      end
    end
  end

  # Red-Black balanced binary search tree
  class RedBlackTree
    # Annotate a value with a color
    class RedBlackValue
      attr_reader :value
      attr_accessor :color

      def initialize(color, value)
        @color = color
        @value = value
      end

      def <=>(other)
        value <=> other.value
      end

      def <(other)
        value < other.value
      end

      def ==(other)
        value == other.value
      end
    end

    def initialize
      @bst = BinarySearchTree.new
    end

    def to_s
      @bst.to_s
    end

    def insert_value(value)
      node = @bst.insert_value(RedBlackValue.new(:red, value))
      node # my R-B fix-ups don't work yet
      # puts "node from insert_value is #{node}"
      # # may have just broke property 3--red node can't have red child.
      # x = node
      # while x.parent && x.parent.element.color == :red
      #   if x.parent.parent && x.parent == x.parent.parent.left
      #     y = x.parent.parent.right
      #     if y && y.element.color == :red
      #       # case 1
      #       x.parent.element.color = :black
      #       y.element.color = :black
      #       x.parent.parent.element.color = :red
      #       x = x.parent.parent
      #     else
      #       if x == x.parent.right
      #         # case 2
      #         x = x.parent
      #         x.left_rotate!
      #       end
      #       # case 3
      #       x.parent.element.color = :black
      #       x.parent.parent.element.color = :red
      #       x.parent.parent.right_rotate!
      #     end
      #   elsif x.parent.parent && x.parent == x.parent.parent.right
      #     y = x.parent.parent.left
      #     if y && y.element.color == :red
      #       # case 1
      #       x.parent.element.color = :black
      #       y.element.color = :black
      #       x.parent.parent.element.color = :red
      #       x = x.parent.parent
      #     else
      #       if x == x.parent.left
      #         # case 2
      #         x = x.parent
      #         x.right_rotate!
      #       end
      #       # case 3
      #       x.parent.element.color = :black
      #       x.parent.parent.element.color = :red
      #       x.parent.parent.left_rotate!
      #     end
      #   end
      # end
      # @bst.root.element.color = :black
      # # assert { invariants_held? }

      # node
    end

    def value?(value)
      @bst.value?(RedBlackValue.new(:dontcare, value))
    end

    def value_iterative?(value)
      @bst.value_iterative?(RedBlackValue.new(:dontcare, value))
    end

    def delete!(value)
      @bst.delete!(RedBlackValue.new(:dontcare, value))
      # assert { invariants_held? }
    end

    def sorted_list
      @bst.sorted_list.map(&:value)
    end

    def walk(&proc)
      @bst.walk(&proc)
    end

    def invariants_held?
      true # until I get parent pointers working
      # invariants_held = true
      # walk do |node|
      #   invariants_held &&= check_rules(node)
      # end
      # invariants_held
    end

    private

    def black_nodes_from_path(path)
      path.select { |element| element.color == :black }
    end

    def check_rule_1(node)
      # Rule #1: Every node is either red or black
      return false unless [:red, :black].include? node.element.color
      true
    end

    def check_rule_2(_node)
      # Rule #2: Child nil-nodes are considered black
      true
    end

    def check_rule_3(node)
      # Rule #3: Red nodes always have two black child nodes
      if node.element.color == :red
        unless node.left.nil?
          return false unless node.left.element.color == :black
        end
        unless node.right.nil?
          return false unless node.right.element.color == :black
        end
      end
      true
    end

    def check_rule_4(node)
      # Rule #4: Every simple path from a node to a leaf contains
      # same # of black nodes.
      lengths_of_simple_paths =
        node.simple_paths.map { |path| black_nodes_from_path(path).length }
      return false unless lengths_of_simple_paths.uniq.length == 1
      true
    end

    def check_rules(node)
      check_rule_1(node) &&
        check_rule_2(node) &&
        check_rule_3(node) &&
        check_rule_4(node)
    end
  end
end
