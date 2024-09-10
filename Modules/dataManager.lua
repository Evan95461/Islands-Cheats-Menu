--// Services
local HttpService = game:GetService("HttpService")

--// Variables
local FOLDER_NAME = "meteor_data"

local saveData = function(fileName, data)
    pcall(function()
        task.spawn(function()
            if isfolder(`{FOLDER_NAME}/`) then
                writefile(`{FOLDER_NAME}/{fileName}.json`, HttpService:JSONEncode(data))
            else
                makefolder(`{FOLDER_NAME}/`)
                writefile(`{FOLDER_NAME}/{fileName}.json`, HttpService:JSONEncode(data))
            end
        end)
    end)
end

local loadData = function(fileName)
    pcall(function()
        if isfolder(`{FOLDER_NAME}/`) then
           return HttpService:JSONDecode(readfile(`{FOLDER_NAME}/{fileName}.json`)) 
        end
        return
    end)
end

return {
    saveData = saveData,
    loadData = loadData
}

