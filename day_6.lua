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

    local line_num = 1;
    local problems = {};
    local ops = {}; -- 0 is add, 1 is mul

    local CreateProblem = function()
        local problem = {
            {0, 0, 0, 0},
            {0, 0, 0, 0},
            {0, 0, 0, 0},
            {0, 0, 0, 0},
            {0, 0, 0, 0, 99999},
        };

        return problem;
    end

    local PushDigitToProblem = function(problem, line, digit)
        assert(type(problem) == "table" and type(line) == "number" and type(digit) == "number");
        assert(line >= 1 and line <= 4 and digit >= 0 and digit <= 9);
        assert(#problem == 5);

        local problem_line = problem[line];
        assert(type(problem_line) == "table" and #problem_line == 4);
        problem_line[1] = problem_line[2];
        problem_line[2] = problem_line[3];
        problem_line[3] = problem_line[4];
        problem_line[4] = digit;
    end

    local SetProblemLineAlignment = function(problem, line, alignment)
        assert(type(problem) == "table" and type(line) == "number" and type(alignment) == "number");
        assert(line >= 1 and line <= 4 and alignment >= 0);
        assert(#problem == 5);

        local alignment_line = problem[5];
        alignment_line[line] = alignment;
        alignment_line[5] = math.min(alignment_line[5], alignment);
    end

    local AlignLine = function(problem_line, alignment)
        assert(type(problem_line) == "table" and #problem_line == 4);
        assert(type(alignment) == "number" and alignment >= 0 and alignment <= 3)
        local first_digit = 1;
        for d = 1, 4 do
            if problem_line[d] ~= 0 then
                first_digit = d;
                break;
            end
        end
        
        if(alignment == first_digit) then
            return;
        end

        assert(alignment < first_digit);

        local i = 1;
        for d = first_digit, 4 do
            local moved_number = problem_line[d];
            problem_line[d] = 0;
            problem_line[i + alignment] = moved_number;
            i = i + 1;
        end
    end

    local AlignProblem = function(problem)
        assert(type(problem) == "table" and #problem == 5);
        local alignment_line = problem[5];
        alignment_line[1] = alignment_line[1] - alignment_line[5];
        alignment_line[2] = alignment_line[2] - alignment_line[5];
        alignment_line[3] = alignment_line[3] - alignment_line[5];
        alignment_line[4] = alignment_line[4] - alignment_line[5];

        for i = 1, 4 do
            AlignLine(problem[i], alignment_line[i]);
        end
    end

    local ExtractNumber = function(problem, number_line)
        assert(type(problem) == "table" and #problem == 5 and type(number_line) == "number" and number_line <= 4 and number_line >= 1);

        local multiplier = 1;
        local total_number = 0;
        for i = 4, 1, -1 do
            local number = problem[i][number_line];
            if number == 0 then
                goto continue;
            end

            total_number = total_number + (number * multiplier);
            multiplier = multiplier * 10;

            ::continue::
        end

        return total_number;
    end

    local ExtractNumbersFromProblem = function(problem)
        assert(type(problem) == "table" and #problem == 5);

        local number_1 = ExtractNumber(problem, 1);
        local number_2 = ExtractNumber(problem, 2);
        local number_3 = ExtractNumber(problem, 3);
        local number_4 = ExtractNumber(problem, 4);

        return number_1, number_2, number_3, number_4;
    end

    for line in input_file:lines() do
        local problem_num = 0;
        local is_in_separator = true;
        local col_num = 1;

        for char in string.gmatch(line, ".") do
            if line_num < 5 then
                if char == " " then
                    is_in_separator = true;
                else
                    local digit = tonumber(char);
                    assert(type(digit) == "number");
                    local problem = nil;

                    if is_in_separator then
                        problem_num = problem_num + 1;
                        is_in_separator = false;
                        if line_num == 1 then
                            table.insert(problems, CreateProblem());
                        end
                        problem = problems[problem_num];
                        SetProblemLineAlignment(problem, line_num, col_num);
                    else
                        problem = problems[problem_num];
                    end

                    assert(type(problem) == "table");
                    PushDigitToProblem(problem, line_num, digit);
                end
            else
                if char ~= " " then
                    if char == "+" then
                        table.insert(ops, 0);
                    elseif char == "*" then
                        table.insert(ops, 1);
                    else
                        assert(false);
                    end
                end
            end
            col_num = col_num + 1;
        end
        
        line_num = line_num + 1;
    end
    input_file:seek("set", 0);

    assert(#problems == #ops);
    for i = 1, #problems do
        local problem = problems[i];
        AlignProblem(problem);
        local num1, num2, num3, num4 = ExtractNumbersFromProblem(problem);

        local problem_result = 0;
        if ops[i] == 0 then
            problem_result = num1 + num2 + num3 + num4;
        else
            num1 = num1 > 0 and num1 or 1;
            num2 = num2 > 0 and num2 or 1;
            num3 = num3 > 0 and num3 or 1;
            num4 = num4 > 0 and num4 or 1;
            problem_result = num1 * num2 * num3 * num4;
        end

        solution = solution + problem_result;
    end

    local end_time = os.clock();
    local final_time = end_time - start_time;

    print("Second part solution!");
    print(string.format("The solution is %d", solution));
    print(string.format("The solution took %f seconds", final_time));
end

SolveFirstPart();
SolveSecondPart();