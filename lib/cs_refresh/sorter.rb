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

  # Uses HeapSort algorithm
  class HeapSorter
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

  # Quicksort implementation
  class QuickSorter
    def sort(arr)
      quicksort(arr, 0, arr.length - 1)
    end

    private

    def quicksort(arr, first_idx, last_idx)
      unless first_idx >= last_idx
        pivot_idx = partition(arr, first_idx, last_idx)
        quicksort(arr, first_idx, pivot_idx)
        quicksort(arr, pivot_idx + 1, last_idx)
      end
      arr
    end

    def partition(arr, first_idx, last_idx)
      pivot_value = arr[first_idx]
      while first_idx < last_idx
        first_idx += 1 while arr[first_idx] < pivot_value
        last_idx -= 1 while arr[last_idx] > pivot_value
        swap(arr, first_idx, last_idx) if first_idx < last_idx
      end
      last_idx
    end

    def swap(arr, a, b)
      tmp = arr[a]
      arr[a] = arr[b]
      arr[b] = tmp
    end
  end

  # Implementation of mergesort algorithm
  class MergeSorter
    def sort(arr)
      if arr.length == 1
        arr
      else
        left_side, right_side = split_and_sort_each(arr)
        left_side = sort(left_side)
        right_side = sort(right_side)
        merge(left_side, right_side)
      end
    end

    private

    def split_and_sort_each(arr)
      middle_idx = ((arr.length - 1) / 2).to_i
      split_on_index(arr, middle_idx)
    end

    def split_on_index(arr, index)
      [arr[0..index], arr[index + 1..(arr.length - 1)]]
    end

    def merge(arr1, arr2)
      Merger.new(arr1, arr2).merged
    end
  end

  # Iterates through an array until done
  class ArrIterator
    attr_reader :idx
    attr_reader :arr

    def initialize(arr)
      @arr = arr
      @idx = 0
    end

    def done?
      idx >= arr.length
    end

    def next
      ret = value
      @idx += 1
      ret
    end

    def value
      @arr[@idx]
    end
  end

  # Merges two pre-sorted arrays
  class Merger
    attr_reader :arr1
    attr_reader :arr2

    def initialize(arr1, arr2)
      @arr1 = ArrIterator.new(arr1)
      @arr2 = ArrIterator.new(arr2)
      @new_arr = []
    end

    def compare_and_merge
      unless arr1.done? || arr2.done?
        if arr1.value < arr2.value
          @new_arr << arr1.next
        else
          @new_arr << arr2.next
        end
      end
    end

    def concat(arr)
      @new_arr << arr.next until arr.done?
    end

    def merged
      compare_and_merge
      # handle left-overs
      concat(arr1)
      concat(arr2)
      @new_arr
    end
  end
end
