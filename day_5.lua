require "utils/strings"
require "utils/sets"

local input_file, error_msg = io.open("inputs\\day5input.txt", "r");
if not input_file then
    print(error_msg);
    return;
end

function DoesRangeIntersect(from_a, to_a, from_b, to_b)
    assert(type(from_a) == "number" and type(to_a) == "number" and type(from_b) == "number" and type(to_b) == "number");
    assert(from_a <= to_a and from_b <= to_b);

    return math.max(from_a, from_b) <= math.min(to_a, to_b);
end

function MergeRanges(from_a, to_a, from_b, to_b)
    assert(type(from_a) == "number" and type(to_a) == "number" and type(from_b) == "number" and type(to_b) == "number");
    assert(from_a <= to_a and from_b <= to_b);
    assert(DoesRangeIntersect(from_a, to_a, from_b, to_b));

    return math.min(from_a, from_b), math.max(to_a, to_b);
end

function IsWithinRange(from, to, value)
    assert(type(from) == "number" and type(to) == "number" and type(value) == "number");
    assert(from <= to);

    return value >= from and value <= to;
end

function InsertNewRange(ranges, from, to)
    assert(type(ranges) == "table" and type(from) == "number" and type(to) == "number");

    for i = 1, #ranges do
        local range = ranges[i];
        if DoesRangeIntersect(from, to, range[1], range[2]) then
            local new_from, new_to = MergeRanges(from, to, range[1], range[2]);
            range[1] = new_from;
            range[2] = new_to;
            return;
        end
    end

    table.insert(ranges, {from, to});
end

function SolveFirstPart()
    local start_time = os.clock();
    local solution = 0;
    
    local reached_ids = false;
    local ranges = {};

    for line in input_file:lines() do
        if #line == 0 then
            reached_ids = true;
            goto continue;
        end

        if not reached_ids then
            local from, to = SplitStringAsNumbers(line, "-");
            InsertNewRange(ranges, from, to);
        else
            local id = tonumber(line);
            assert(type(id) == "number");

            for i = 1, #ranges do
                if IsWithinRange(ranges[i][1], ranges[i][2], id) then
                    solution = solution + 1;
                    break;
                end
            end
        end

        ::continue::
    end
    input_file:seek("set", 0);

    local end_time = os.clock();
    local final_time = end_time - start_time;
   
    print("First part solution!");
    print(string.format("The solution is %d", solution));
    print(string.format("The solution took %f seconds", final_time));
end


function SolveSecondPart()
    local start_time = os.clock();
    local solution = 0;

    local reached_ids = false;
    local ranges = {};

    for line in input_file:lines() do
        if #line == 0 then
            break;
        end

        local from, to = SplitStringAsNumbers(line, "-");
        InsertNewRange(ranges, from, to);
    end
    input_file:seek("set", 0);

    for i = #ranges, 1, -1 do
        local range = table.remove(ranges, i);
        InsertNewRange(ranges, range[1], range[2]);
    end

    for i = 1, #ranges do
        local range_span = ranges[i][2] - ranges[i][1] + 1;
        solution = solution + range_span;
    end

    local end_time = os.clock();
    local final_time = end_time - start_time;

    print("Second part solution!");
    print(string.format("The solution is %d", solution));
    print(string.format("The solution took %f seconds", final_time));
end

SolveFirstPart();
SolveSecondPart();