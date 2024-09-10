--// Services
local HttpService = game:GetService("HttpService")

--// Variables
local FOLDER_NAME = "meteor_data"

local loadData = function(fileName)
    pcall(function()
        if isfolder(`{FOLDER_NAME}/`) then
           return HttpService:JSONDecode(readfile(`{FOLDER_NAME}/{fileName}.json`)) 
        end
        return
    end)
end

local saveData = function(fileName, data)
    pcall(function()
        task.spawn(function()
            local previousData = loadData(fileName)
            table.insert(previousData, data)
            if isfolder(`{FOLDER_NAME}/`) then
                writefile(`{FOLDER_NAME}/{fileName}.json`, HttpService:JSONEncode(previousData))
            else
                makefolder(`{FOLDER_NAME}/`)
                writefile(`{FOLDER_NAME}/{fileName}.json`, HttpService:JSONEncode(previousData))
            end
        end)
    end)
end

return {
    saveData = saveData,
    loadData = loadData
}

