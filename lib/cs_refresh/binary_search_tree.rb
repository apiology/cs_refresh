require_relative 'tree'

module CsRefresh
  # My implementation of a binary search tree
  class BinarySearchTree
    def sorted_list
      if @tree.nil?
        []
      else
        @tree.dfs_in_order_iterative
      end
    end

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
      tree, _parent = find_tree_and_parent(value)
      tree
    end

    def find_tree_and_parent(value, tree = @tree, parent = nil)
      if tree.nil?
        nil
      elsif value == tree.element
        [tree, parent]
      elsif value < tree.element
        find_tree_and_parent(value, tree.left, tree)
      else # value > tree.element
        find_tree_and_parent(value, tree.right, tree)
      end
    end

    def delete!(value, tree = @tree, parent = nil)
      if value == tree.element
        remove_from_parent(tree, parent)
      elsif value < tree.element
        delete!(value, tree.left, tree)
      else
        delete!(value, tree.right, tree)
      end
    end

    def left_rotate!(value)
      tree, parent = find_tree_and_parent(value)
      fail if tree.nil?
      tree.left_rotate!(parent)
    end

    def remove_from_parent(tree, parent)
      if tree == @tree
        @tree = nil
      else
        remove_from_nonnil_parent(tree, parent)
      end
    end

    def remove_from_nonnil_parent(tree, parent)
      # parent must be set
      if tree.left
        parent.replace(tree, tree.left)
        tree.left = nil
      elsif tree.right
        parent.replace(tree, tree.right)
        tree.right = nil
      else
        parent.replace(tree, nil)
        tree.right = nil
      end
    end

    def to_s
      @tree.to_s
    end
  end
end
