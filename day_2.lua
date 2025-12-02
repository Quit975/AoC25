require "utils/strings"
require "utils/sets"

local input_file, error_msg = io.open("inputs\\day2input.txt", "r");
if not input_file then
    print(error_msg);
    return;
end

function SolveFirstPart()
    local start_time = os.clock();
    local solution = 0;
    
    for line in input_file:lines() do
        local current_span, remaining_string = SplitString(line, ",");
        while remaining_string do
            local left, right = SplitStringAsNumbers(current_span, "-");
            assert(left and right);
            assert(right > left);

            print(string.format("From %d to %d", left, right));

            current_span, remaining_string = SplitString(remaining_string, ",");
        end

        local left, right = SplitStringAsNumbers(current_span, "-");
        assert(left and right);
        assert(right > left);
        print(string.format("From %d to %d", left, right));
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