local SaveData = Class{}

function SaveData:init(path)
    if not path then
        self.data = {}
    else
        self.data = SaveData.loadData(path)
    end
end

function SaveData:levelComplete(worldName, id)
    if self.data[worldName] then
        self.data[worldName][id] = true
    else
        self.data[worldName] = {}
        self.data[worldName][id] = true
    end
end

function SaveData:isLevelComplete(worldName, id)
    return self.data[worldName] and self.data[worldName][id]
end

function SaveData:loadData(path)
    return {}
end

return SaveData