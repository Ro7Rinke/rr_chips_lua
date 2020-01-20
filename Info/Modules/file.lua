function openFile(url, data)
	if data ~= nil then
        local file = io.open(url,"w")
        if file == nil then
            return nil
        end
		file:write(data)
		file:flush()
		file:close()
	else
        local file = io.open(url,'r')
        if file == nil then
            return nil
        end
		file:seek('set')
		data = file:read('*all')
		file:close()
		return data
	end
end