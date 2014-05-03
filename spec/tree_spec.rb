# -*- coding: utf-8 -*-
require 'spec_helper'
require 'cs_refresh'

SAMPLE_TREE = lambda do |f|
  f.call(9,
         f.call(12,
                f.call(19)),
         f.call(8,
                f.call(23,
                       f.call(62),
                       f.call(91)),
                f.call(52)))
end

SAMPLE_DFS_PRE_ORDER = [9, 12, 19, 8, 23, 62, 91, 52]
SAMPLE_DFS_IN_ORDER = [19, 12, 9, 62, 23, 91, 8, 52]
SAMPLE_DFS_POST_ORDER = [19, 12, 62, 91, 23, 52, 8, 9]

SAMPLE_BFS = [9, 12, 8, 19, 23, 52, 62, 91]

def test_pre_order(tree)
  it "Should do DFS pre-order traversal of #{tree}" do
    expect(tree.dfs_pre_order).to eq SAMPLE_DFS_PRE_ORDER
    expect(tree.dfs_pre_order_iterative).to eq SAMPLE_DFS_PRE_ORDER
  end
end

def test_post_order(tree)
  it "Should do DFS post-order traversal of #{tree}" do
    expect(tree.dfs_post_order).to eq SAMPLE_DFS_POST_ORDER
    expect(tree.dfs_post_order_iterative).to eq SAMPLE_DFS_POST_ORDER
  end
end

def test_in_order(tree)
  it "Should do DFS in-order traversal of #{tree}" do
    expect(tree.dfs_in_order).to eq SAMPLE_DFS_IN_ORDER
    expect(tree.dfs_in_order_iterative).to eq SAMPLE_DFS_IN_ORDER
  end
end

def test_bfs(tree)
  it "Should do BFS traversal of #{tree}" do
    expect(tree.bfs).to eq SAMPLE_BFS
  end
end

def test_traversals(tree)
  test_pre_order(tree)
  test_post_order(tree)
  test_in_order(tree)
  test_bfs(tree)
end

def test(binary_tree_class)
  describe binary_tree_class do
    f = lambda do |value, left = nil, right = nil|
      binary_tree_class.new(value, left, right)
    end
    tree = SAMPLE_TREE.call(f)
    test_traversals(tree)
  end
end


# NEXT: Array-based tree storage?
[CsRefresh::BinaryTree].each do |binary_tree_class|
  test(binary_tree_class)
end
