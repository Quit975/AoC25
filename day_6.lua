require "utils/strings"
require "utils/sets"

local input_file, error_msg = io.open("inputs\\day6input.txt", "r");
if not input_file then
    print(error_msg);
    return;
end

function SolveFirstPart()
    local start_time = os.clock();
    local solution = 0;
    
    local line_num = 1;
    local numbers = {};
    local ops = {}; -- 0 is add, 1 is mul

    for line in input_file:lines() do
        local word_num = 1;

        for word in string.gmatch(line, "%g+") do
            if line_num < 5 then
                if line_num == 1 then
                    table.insert(numbers, {});
                end

                local number = tonumber(word);
                assert(type(number) == "number");
                table.insert(numbers[word_num], number);
            else
                if word == "+" then
                    table.insert(ops, 0);
                elseif word == "*" then
                    table.insert(ops, 1);
                else
                    assert(false);
                end
            end

            word_num = word_num + 1;
        end
        
        line_num = line_num + 1;
    end
    input_file:seek("set", 0);

    assert(#numbers == #ops);
    for i = 1, #numbers do
        local problem_numbers = numbers[i];
        local problem_result = 0;

        if ops[i] == 0 then
            -- add
            for k = 1, #problem_numbers do
                problem_result = problem_result + problem_numbers[k];
            end
        else
            -- mul
            problem_result = 1;
            for k = 1, #problem_numbers do
                problem_result = problem_result * problem_numbers[k];
            end
        end

        solution = solution + problem_result;
    end

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