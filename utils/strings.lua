function TrimString(input)
    local res = string.gsub(input, "^%s+", "");
    res = string.gsub(res, "%s+$", "");
    return res;
end

function SplitString(input, splitting_character)
    local idx = string.find(input, splitting_character);
    if not idx then return nil, nil end;

    local left = string.sub(input, 1, idx - 1);
    local right = string.sub(input, idx + 1, string.len(input));
    return TrimString(left), TrimString(right);
end

function SplitStringAsNumbers(input, splitting_character)
    local left, right = SplitString(input, splitting_character)
    local left_result = left and tonumber(left) or nil
    local right_result = right and tonumber(right) or nil

    return left_result, right_result
end