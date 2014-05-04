require_relative 'tree'

module CsRefresh
  # My implementation of a binary search tree
  class BinarySearchTree
    def insert_value(value)
      if @tree.nil?
        @tree = BinaryTree.new(value)
      else
        push_down(value, @tree)
      end
    end

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
      else
        push_down(value, tree.left)
      end
    end

    def push_down_right(value, tree)
      if tree.right.nil?
        tree.right = BinaryTree.new(value)
      else
        push_down(value, tree.right)
      end
    end

    def value?(value, tree = @tree)
      if tree.nil?
        false
      else
        value_in_real_tree?(value, tree)
      end
    end

    def value_in_real_tree?(value, tree)
      if value == tree.element
        true
      elsif value < tree.element
        value?(value, tree.left)
      else # value > tree.element
        value?(value, tree.right)
      end
    end

    def to_s
      @tree.to_s
    end
  end
end
