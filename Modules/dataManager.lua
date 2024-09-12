--// Services
local HttpService = game:GetService("HttpService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

--// Variables
local FOLDER_NAME = "meteor_data"

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
            table.insert(dataToSave, data)
            if isfolder(`{FOLDER_NAME}/`) then
                writefile(`{FOLDER_NAME}/{fileName}.json`, HttpService:JSONEncode(dataToSave))
            else
                makefolder(`{FOLDER_NAME}/`)
                writefile(`{FOLDER_NAME}/{fileName}.json`, HttpService:JSONEncode(dataToSave))
            end
        end)
    end)
end

return {
    saveData = saveData,
    loadData = loadData
}

