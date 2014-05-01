require 'algorithms'

module CsRefresh
  # Sorts arrays of items
  class SystemSorter
    def sort(arr)
      arr.sort
    end
  end

  # Reverse how the embedded item sorts
  class ReversedSortingOrder
    attr_reader :item

    def initialize(item)
      @item = item
    end

    def <=>(other)
      orig = (@item <=> other.item)
      return nil if orig.nil?
      0 - orig
    end
  end

  # Represents a heap.  Abstract.
  class Heap
    def push_all(arr)
      arr.each { |item| push(item) }
    end
  end

  # Third-party heap implementation to test against.
  class SystemMinHeap < Heap
    def initialize
      @pq = Containers::PriorityQueue.new
    end

    def push(item)
      @pq.push(item,
               ReversedSortingOrder.new(item))
    end

    def empty?
      @pq.empty?
    end

    def pop_min
      @pq.pop
    end
  end

  # My implemenation of a min heap
  class VinceMinHeap < Heap
    def initialize
      @heap_arr = []
    end

    def push(item)
      @heap_arr << item
      promote(last_position)
    end

    def empty?
      @heap_arr.empty?
    end

    def pop_min
      min = @heap_arr[0]
      last = @heap_arr[last_position]
      # reduce array size by one
      @heap_arr.slice!(last_position)
      if @heap_arr.size > 0
        @heap_arr[0] = last
        push_down(0)
      end
      min
    end

    private

    def last_position
      @heap_arr.length - 1
    end

    def push_down(position)
      if right_child?(position) && left_child?(position)
        push_down_has_both_children(position)
      elsif right_child?(position)
        push_down_to_right(position)
      elsif left_child?(position)
        push_down_to_left(position)
      else
        # do nothing - we are at bottom
      end
    end

    def push_down_to_left(position)
      left = @heap_arr[left_child_position(position)]
      element = @heap_arr[position]
      if element > left
        swap(position, left_child_position(position))
        push_down(left_child_position(position))
      end
    end

    def push_down_to_right(position)
      right = @heap_arr[right_child_position(position)]
      element = @heap_arr[position]
      if element > right
        swap(position, right_child_position(position))
        push_down(right_child_position(position))
      end
    end

    def push_down_has_both_children(position)
      right = @heap_arr[right_child_position(position)]
      left = @heap_arr[left_child_position(position)]
      if right > left
        push_down_to_left(position)
      else
        push_down_to_right(position)
      end
    end

    def push_to_end(position)
      unless position == @heap_arr.length - 1
        if right_child?(position)
          swap(position, right_child_position(position))
        elsif left_child?(position)
          swap(position, left_child_position(position))
        else
          fail "No right or left child for #{position} in arr of #{@heap_arr}"
        end
      end
    end

    def swap(position_a, position_b)
      temp = @heap_arr[position_a]
      @heap_arr[position_a] = @heap_arr[position_b]
      @heap_arr[position_b] = temp
    end

    def right_child?(position)
      right_child_position(position) < @heap_arr.length
    end

    def left_child?(position)
      left_child_position(position) < @heap_arr.length
    end

    def promote(position)
      unless position == 0
        parent_position = parent(position)
        if @heap_arr[position] < @heap_arr[parent(position)]
          swap(position, parent_position)
          promote(parent_position)
        end
      end
    end

    def parent(position)
      (position / 2).to_i
    end

    def right_child_position(position)
      position + 2
    end

    def left_child_position(position)
      position + 1
    end

    def to_s
      @heap_arr.to_s
    end
  end

  # Uses MergeSort algorithm
  class MergeSorter
    def initialize(heap)
      @heap = heap
    end

    def sort(arr)
      @heap.push_all(arr)
      new_arr = []
      new_arr << @heap.pop_min until @heap.empty?
      new_arr
    end
  end
end
