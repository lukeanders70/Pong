function getOrElse(t, k, default, errorMessage)
    if not (t[k] == nil) then
        return t[k]
    else
        if errorMessage then
            logger("e", errorMessage)
        end
        return default
    end
end

function replaceIfNil(v, default)
    if v == nil then 
        return default
     else
         return v 
    end
end

function logger(level, message)
    local tag = "UNKNOWN SEV"
    if level == "d" then
        tag = "DEBUG"
    elseif level == "w" then
        tag = "WARNING"
    elseif level == "e" then
        tag ="ERROR"       
    end
    print(tag .. ": " .. message)
end

function vectorSub(v1, v2)
    return {x = v1.x - v2.x, y = v1.y - v2.y}
end

function vectorLength(v)
    return math.sqrt((v.x*v.x) + (v.y*v.y))
end

function vectorNormalize(v)
    local length = vectorLength(v)
    if not (length == 0) then
        return {x = v.x/length, y = v.y/length}
    else
        return {x = 0, y = 0}
    end
end

function round(x)
    return math.floor(x + 0.5)
end

function table.clone(org)
    return {unpack(org)}
end

function table.filter(t, fun)
    local newTable = {}
    for k, v in pairs(t) do
        if fun(k, v) then
            table.insert(newTable, v)
        end
    end
    return newTable
end

function table.min(t, f)
    assert(t)
    local comparer = f or function(v)
        return v
    end
    local lowest = comparer(t[1])
    local lowestBase = t[1]
    for _, val in pairs(t) do
        if comparer(val) < lowest then
            lowestBase = val
            lowest = comparer(val)
        end
    end
    return lowestBase
end