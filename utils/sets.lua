Set = {}

function Set.New (t)
    local set = {}
    local size = 0
    for _, l in ipairs(t) do
        if not set[l] then
            size = size + 1;
            set[l] = true;
        end
    end
    return set, size
end

function Set.NewFromSet (set)
    local res = {}
    local size = 0
    for k in pairs(set) do
        size = size + 1;
        res[k] = true;
    end
    return res, size
end

function Set.Union (a,b)
    local res = Set.New{}
    local size = 0
    for k in pairs(a) do res[k] = true end
    for k in pairs(b) do res[k] = true end
    for _ in pairs(res) do size = size + 1 end
    return res, size
end

function Set.Intersection (a,b)
    local res = Set.New{}
    local size = 0
    for k in pairs(a) do
        res[k] = b[k]
        if res[k] then
            size = size + 1
        end
    end
    return res, size
end

function Set.Complement(universal_set, tested_set)
    local res, size = Set.NewFromSet(universal_set);
    for k in pairs(tested_set) do
        if Set.Remove(res, k) then
            size = size - 1;
        end
    end

    return res, size;
end

function Set.Add(set, element)
    if not set[element] then
        set[element] = true;
        return true;
    else
        return false;
    end
end

function Set.Remove(set, element)
    if set[element] then
        set[element] = false;
        return true;
    else
        return false;
    end
end

function Set.ToArray(set)
    local res = {};
    for k in pairs(set) do
        if set[k] then
            table.insert(res, k);
        end
    end
    return res;
end