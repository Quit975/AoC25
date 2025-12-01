require "utils/strings"
require "utils/sets"

local input_file, error_msg = io.open("inputs\\day1input.txt", "r");
if not input_file then
    print(error_msg);
    return;
end

function SolveFirstPart()
    local start_time = os.clock();
    local solution = 0;

    local current_dial = 50;
    local max_dial = 99;

    for line in input_file:lines() do
        local direction_string = string.sub(line, 1, 1);
        local turn_to_left = direction_string == "L" and true or false;
        local turn_amount = tonumber(string.sub(line, 2));
        assert(type(turn_amount) == "number");

        local actual_turn_amount = turn_amount % (max_dial + 1) ;
        if turn_to_left then
            actual_turn_amount = -actual_turn_amount;
        end

        current_dial = current_dial + actual_turn_amount;
        if current_dial < 0 then
            current_dial = (max_dial + 1) + current_dial;
        elseif current_dial > max_dial then
            current_dial = current_dial - (max_dial + 1);
        end

        if current_dial == 0 then
            solution = solution + 1;
        end
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

    local current_dial = 50;
    local max_dial = 99;

    for line in input_file:lines() do
        local direction_string = string.sub(line, 1, 1);
        local turn_to_left = direction_string == "L" and true or false;
        local turn_amount = tonumber(string.sub(line, 2));
        assert(type(turn_amount) == "number");

        local overflow_turns = math.floor(turn_amount / (max_dial + 1));
        solution = solution + overflow_turns;

        local actual_turn_amount = turn_amount % (max_dial + 1) ;
        if turn_to_left then
            actual_turn_amount = -actual_turn_amount;
        end

        local was_zero = current_dial == 0;
        current_dial = current_dial + actual_turn_amount;
        if current_dial < 0 then
            current_dial = (max_dial + 1) + current_dial;
            if not was_zero then
                solution = solution + 1;
            end
        elseif current_dial > max_dial then
            current_dial = current_dial - (max_dial + 1);
            if not (current_dial == 0) then
                solution = solution + 1;
            end
        end

        if current_dial == 0 then
            solution = solution + 1;
        end
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