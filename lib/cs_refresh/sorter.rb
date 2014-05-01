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
      promote(@heap_arr.size - 1)
    end

    def empty?
      @heap_arr.empty?
    end

    def pop_min
      min = @heap_arr[0]
      # reduce array size by one
      push_to_end(0)
      @heap_arr.slice!(@heap_arr.length - 1)
      min
    end

    private

    def push_to_end(position)
      unless position == @heap_arr.length - 1
        if right_child?(position)
          swap(position, right_child(position))
        elsif left_child?(position)
          swap(position, left_child(position))
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
      right_child(position) < @heap_arr.length
    end

    def left_child?(position)
      left_child(position) < @heap_arr.length
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

    def right_child(position)
      position + 2
    end

    def left_child(position)
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
      until @heap.empty?
        puts "Heap is now #{@heap}"
        new_arr << @heap.pop_min
      end
      new_arr
    end
  end
end
