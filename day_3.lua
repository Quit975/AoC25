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

        if highest_single == 0 then
            highest_single = GetDigitAtStringPos(line, #line);
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


function SolveSecondPart()
    local start_time = os.clock();
    local solution = 0;

    for line in input_file:lines() do
        
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