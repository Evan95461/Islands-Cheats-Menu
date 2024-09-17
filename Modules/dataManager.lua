--// Services
local HttpService = game:GetService("HttpService")

--// Variables
local FOLDER_NAME = "meteor_data"

-- Utils

-- find an element in a table
local function deepFind(table, targetElement)
    for index, value in table do
        if value == targetElement then
            return index
        end
        if type(value) == "table" then
            deepFind(value, targetElement)
        end
    end
    return nil
end

-- Get data in a specific file
local loadData = function(fileName)
    local success, result = pcall(function()
        if isfolder(`{FOLDER_NAME}/`) then
           return HttpService:JSONDecode(readfile(`{FOLDER_NAME}/{fileName}.json`))
        else
           return
        end
    end)

    if success then return result end
end

-- Save data in a specific file
local saveData = function(fileName, data)
    pcall(function()
        task.spawn(function()
            local dataToSave = {}
            local previousData = loadData(fileName)
            if previousData ~= nil then
                for _, pdata in previousData do
                    table.insert(dataToSave, pdata)
                end
            end
            if type(data) == "table" then
                for _, dataInTable in data do
                    table.insert(dataToSave, dataInTable)
                end
            else
                table.insert(dataToSave, data)
            end
            if not isfolder(`{FOLDER_NAME}/`) then
                makefolder(`{FOLDER_NAME}/`)
            end
            writefile(`{FOLDER_NAME}/{fileName}.json`, HttpService:JSONEncode(dataToSave))
        end)
    end)
end

-- Delete a data in a specific file
local deleteData = function(fileName, element)
    pcall(function()
        if isfolder(`{FOLDER_NAME}/`) then
            local data = loadData(fileName)
            local indexToRemove = deepFind(data, element)
            table.remove(data, indexToRemove)

            writefile(`{FOLDER_NAME}/{fileName}.json`, HttpService:JSONEncode(data))
        else
            return
        end
    end)
end

return {
    saveData = saveData,
    loadData = loadData,
    deleteData = deleteData
}

