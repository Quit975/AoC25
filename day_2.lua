require "utils/strings"
require "utils/sets"

local input_file, error_msg = io.open("inputs\\day2input.txt", "r");
if not input_file then
    print(error_msg);
    return;
end

function MakeDoubleNumber(number)
    assert(number and type(number) == "number");
    local number_as_string = tostring(number);
    local double_number_as_string = number_as_string .. number_as_string;
    return tonumber(double_number_as_string);
end

function GetHalfNumber(number)
    assert(number and type(number) == "number");
    local number_as_string = tostring(number);
    local number_length = #number_as_string;
    assert((number_length % 2) == 0);
    local number_half_idx = number_length / 2;
    local half_number_as_string = string.sub(number_as_string, 1, number_half_idx);
    return tonumber(half_number_as_string);
end

function GetMaxNumberOfLength(number_length)
    assert(type(number_length) == "number" and number_length > 0);
    local string_num = "";
    for i = 1, number_length do
        string_num = string_num .. "9";
    end
    return tonumber(string_num);
end

function SolveFirstPart()
    local start_time = os.clock();
    local solution = 0;

    local CheckRange = function(left_number, right_number, current_solution)
        assert(type(left_number) == "number" and type(right_number) == "number" and type(current_solution) == "number");

        local left_len = math.floor(math.log(left_number, 10)) + 1;
        local right_len = math.floor(math.log(right_number, 10)) + 1;
        local from_number = left_number;
        local to_number = right_number;

        if left_len == right_len then
            if left_len % 2 ~= 0 then
                return current_solution;
            end
        else
            if left_len % 2 == 0 then
                to_number = GetMaxNumberOfLength(left_len);
            else
                from_number = GetMaxNumberOfLength(left_len) + 1;
            end
        end

        local left_half_num = GetHalfNumber(from_number);
        local left_double_num = MakeDoubleNumber(left_half_num);

        if left_double_num < from_number then
            left_half_num = left_half_num + 1;
            left_double_num = MakeDoubleNumber(left_half_num);
        end

        while left_double_num <= to_number do
            current_solution = current_solution + left_double_num;
            left_half_num = left_half_num + 1;
            left_double_num = MakeDoubleNumber(left_half_num);
        end

        return current_solution;
    end
    
    for line in input_file:lines() do
        local current_span, remaining_string = SplitString(line, ",");
        while remaining_string do
            local left, right = SplitStringAsNumbers(current_span, "-");
            assert(left and right);
            assert(right > left);

            solution = CheckRange(left, right, solution);
            
            current_span, remaining_string = SplitString(remaining_string, ",");
        end

        local left, right = SplitStringAsNumbers(current_span, "-");
        assert(left and right);
        assert(right > left);

        solution = CheckRange(left, right, solution);
    end
    input_file:seek("set", 0);

    local end_time = os.clock();
    local final_time = end_time - start_time;
   
    print("First part solution!");
    print(string.format("The solution is %d", solution));
    print(string.format("The solution took %f seconds", final_time));
end

function BuildNumberFromDuplicates(number_base_string, number_length)
    assert(type(number_base_string) == "string" and type(number_length) == "number");
    assert(number_length % #number_base_string == 0);

    local number_result_string = "";
    local num_iter = number_length / #number_base_string;
    for i = 1, num_iter do
        number_result_string = number_result_string .. number_base_string;
    end

    return number_result_string;
end

function SolveSecondPart()
    local start_time = os.clock();
    local solution = 0;

    local CheckRange = function(left_number_string, right_number_string, current_solution)
        assert(type(left_number_string) == "string" and type(right_number_string) == "string" and type(current_solution) == "number");

        local left_len = #left_number_string;
        local right_len = #right_number_string;
        local left_number = tonumber(left_number_string);
        local right_number = tonumber(right_number_string);

        local starting_solution = current_solution;

        local already_added_ids = Set.New({});

        for i = 1, left_len - 1 do
            if left_len % i ~= 0 then
                goto continue;
            end

            local number_base_string = string.sub(left_number_string, 1, i);
            local max_number_for_base = GetMaxNumberOfLength(i);

            for j = tonumber(number_base_string), max_number_for_base do
                number_base_string = tostring(j);
                local next_invalid_id = tonumber(BuildNumberFromDuplicates(number_base_string, left_len));
                if next_invalid_id > right_number then
                    break;
                end

                if next_invalid_id >= left_number then
                    if already_added_ids[next_invalid_id] == nil then
                        current_solution = current_solution + next_invalid_id;
                        Set.Add(already_added_ids, next_invalid_id);
                    end
                end
            end

            ::continue::
        end

        if right_len > left_len then
            local from_number = GetMaxNumberOfLength(left_len) + 1;
            local from_number_string = tostring(from_number);

            for i = 1, right_len - 1 do
                if right_len % i ~= 0 then
                    goto continue;
                end

                local number_base_string = string.sub(from_number_string, 1, i);
                local max_number_for_base = GetMaxNumberOfLength(i);

                for j = tonumber(number_base_string), max_number_for_base do
                    number_base_string = tostring(j);
                    local next_invalid_id = tonumber(BuildNumberFromDuplicates(number_base_string, right_len));
                    if next_invalid_id > right_number then
                        break;
                    end

                    if already_added_ids[next_invalid_id] == nil then
                        current_solution = current_solution + next_invalid_id;
                        Set.Add(already_added_ids, next_invalid_id);
                    end
                end

                ::continue::
            end
        end

        assert(starting_solution <= current_solution);
        return current_solution;
    end
    
    for line in input_file:lines() do
        local current_span, remaining_string = SplitString(line, ",");
        while remaining_string do
            local left, right = SplitString(current_span, "-");
            assert(left and right);

            solution = CheckRange(left, right, solution);
            
            current_span, remaining_string = SplitString(remaining_string, ",");
        end

        local left, right = SplitString(current_span, "-");
        assert(left and right);

        solution = CheckRange(left, right, solution);
    end
    input_file:seek("set", 0);

    local end_time = os.clock();
    local final_time = end_time - start_time;

    print("Second part solution!");
    print(string.format("The solution is %d", solution));
    print(string.format("The solution took %f seconds", final_time));
end

SolveFirstPart();
SolveSecondPart();