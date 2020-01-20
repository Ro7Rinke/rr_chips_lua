function findInArray (array, data)
    for i = 1, #array do
        if array[i] == data then
            return true
        end
    end
    return false
end