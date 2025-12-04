function TrimString(input)
    local res = string.gsub(input, "^%s+", "");
    res = string.gsub(res, "%s+$", "");
    return res;
end

function SplitString(input, splitting_character)
    assert(splitting_character);
    local idx = string.find(input, splitting_character);
    if not idx then return input, nil end;

    local left = string.sub(input, 1, idx - 1);
    local right = string.sub(input, idx + 1, string.len(input));
    return TrimString(left), TrimString(right);
end

function SplitStringAsNumbers(input, splitting_character)
    assert(splitting_character);
    local left, right = SplitString(input, splitting_character)
    local left_result = left and tonumber(left) or nil
    local right_result = right and tonumber(right) or nil

    return left_result, right_result
end

function GetDigitAtStringPos(input_string, pos)
    assert(type(input_string) == "string" and type(pos) == "number");
    assert(pos <= #input_string);
    local char_at_pos = string.sub(input_string, pos, pos);
    local as_number = tonumber(char_at_pos);
    assert(type(as_number) == "number");
    return as_number;
end