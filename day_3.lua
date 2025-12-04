require "utils/strings"
require "utils/sets"

local input_file, error_msg = io.open("inputs\\day3input.txt", "r");
if not input_file then
    print(error_msg);
    return;
end

function SolveFirstPart()
    local start_time = os.clock();
    local solution = 0;
    
    for line in input_file:lines() do
        local highest_decimal = 0;
        local highest_single = 0;
        for i = 1, #line - 1 do
            local number = GetDigitAtStringPos(line, i);

            if number > highest_decimal then
                highest_decimal = number;
                highest_single = 0;
            elseif number > highest_single then
                highest_single = number;
            end
        end

        local last_digit = GetDigitAtStringPos(line, #line);
        if last_digit > highest_single then
            highest_single = last_digit;
        end

        solution = solution + (highest_decimal * 10) + highest_single;
    end
    input_file:seek("set", 0);

    local end_time = os.clock();
    local final_time = end_time - start_time;
   
    print("First part solution!");
    print(string.format("The solution is %d", solution));
    print(string.format("The solution took %f seconds", final_time));
end

function PushJoltage(joltage, joltage_array, pos)
    assert(type(joltage) == "number" and type(joltage_array) == "table");
    assert(type(pos) == "nil" or (type(pos) == "number" and pos <= 12));

    local at_pos = pos and pos or 1;

    if joltage >= joltage_array[at_pos] then
        local pushed_joltage = joltage_array[at_pos];
        joltage_array[at_pos] = joltage;
        if at_pos < 12 then
            PushJoltage(pushed_joltage, joltage_array, at_pos + 1);
        end
    end
end

function SolveSecondPart()
    local start_time = os.clock();
    local solution = 0;

    for line in input_file:lines() do
        local joltages = GetNumberAtStringPosAsArray(line, #line - 11, 11);
        for i = #line - 12, 1, -1 do
            local number = GetDigitAtStringPos(line, i);
            PushJoltage(number, joltages);
        end

        local bank_output = 100000000000 * joltages[1] +
                            10000000000 * joltages[2] +
                            1000000000 * joltages[3] +
                            100000000 * joltages[4] +
                            10000000 * joltages[5] +
                            1000000 * joltages[6] +
                            100000 * joltages[7] +
                            10000 * joltages[8] +
                            1000 * joltages[9] +
                            100 * joltages[10] +
                            10 * joltages[11] +
                            1 * joltages[12];

        solution = solution + bank_output;
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