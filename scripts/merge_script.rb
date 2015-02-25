require 'csv'

arr2 = CSV.read("JH1.csv", 'r')
# File with more rows
arr1 = CSV.read("JH2.csv", 'r')


# Length of the header for the output file (to find the number of columns).
header = arr1[0].length

# Merge rows from arr2 to rows in arr1 that share the same ID (does it for the header too).
arr1.each_with_index do |v, i|
  arr2.each_with_index do |x, y|
    if arr1[i][0] == arr2[y][0]
      arr1[i].push(arr2[y])
    end
  end
end

# Append rows that are unique to the end of the file. Add '' to keep the columns intact.
for x in 0..(arr2.length - 1)
  for y in 0..(arr1.length - 1)
    if arr1[y][0] == arr2[x][0]
      break
    elsif y == arr1.length - 1
      temp = arr2[x]
      # Created headerT so that all appended rows get shifted and because arr1 has already been modified.
      headerT = header
      while headerT != 0
        temp.unshift('')
        headerT -= 1
      end
      arr1.push(temp)
    end
  end
end

# Flatten the addded arrays to maintain a 2D array.
arr1.each do |x|
  x.flatten!
end

# For the terminal/debugging.
arr1.each do |x|
  p x
  puts ""
end

# Output the array to a new file.
CSV.open("JHF.csv", 'w') do |csv|
  arr1.each do |x|
    csv << x
  end
end
