require 'csv'

# File created from first script.
# Remember to left-right sort first!
arr = CSV.read("JHF.csv", 'r')

# If both columns share the same header, moves the information to the left column.
# Does not do anything if there are any merge conflicts (no blanks or not the same words).
for y in 0..arr[0].length
  z = y + 1
  if arr[0][y] == arr[0][z]
    for a in 1..(arr.length - 1)
      if arr[a][y] == arr[a][z]
        arr[a][z] = ''
      elsif arr[a][y] == nil && arr[a][z] != nil
        arr[a][y] = arr[a][z]
        arr[a][z] = ''
      end
    end
  end
end

# If the whole column is blank, blanks out the column name so that it can be checked and removed.
# Scans each column one by one.
for y in 0..arr[0].length
  not_empty = 0
  arr.each_with_index do |v, i|
    if i + 1 == arr.length then break
    else
      # Checks every cell to see if there is something in it.
      # Could have used a boolean instead. Same same.
      if arr[i+1][y] == nil then nil
      elsif arr[i+1][y].length > 1 then not_empty += 1
      elsif !arr[i+1][y].empty? then not_empty += 1
      end
    end
  end
  if not_empty == 0 then arr[0][y] = '' end
end

# Output the array to a new file.
CSV.open("JHF2.csv", 'w') do |csv|
  arr.each do |x|
    csv << x
  end
end
