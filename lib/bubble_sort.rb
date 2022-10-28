def bubble_sort(arr)
  arr.each_with_index do | element, index |
    arr.each_with_index do | element2, index2 |
      if(index2+1<arr.length)
        if(arr[index2]>arr[index2+1]) 
          temp = arr[index2]
          arr[index2] = arr[index2+1]
          arr[index2+1] = temp
        end
      end
    end
  end
end

p bubble_sort([4,3,78,2,0,2])