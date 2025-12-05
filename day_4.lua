require "utils/strings"
require "utils/sets"

local input_file, error_msg = io.open("inputs\\day4input.txt", "r");
if not input_file then
    print(error_msg);
    return;
end

function SolveFirstPart()
    local start_time = os.clock();
    local solution = 0;

    local rolls = {};
    local access_scores = {};

    local width = 140;
    local height = 140;

    for line in input_file:lines() do
        table.insert(rolls, {});
        table.insert(access_scores, {});

        local current_rolls_line = rolls[#rolls];
        local current_scores_line = access_scores[#access_scores];

        for i = 1, #line do
            table.insert(current_scores_line, 0);
            if string.sub(line, i, i) == "@" then
                table.insert(current_rolls_line, 1);
            else
                table.insert(current_rolls_line, 0);
            end
        end
    end
    input_file:seek("set", 0);

    local IncrementScoreAt = function(score_table, x, y)
        assert(type(score_table) == "table" and type(x) == "number" and type(y) == "number");
        assert(x > 0 and x <= width and y > 0 and y <= height);

        if x > 1 then
            if y > 1 then
                score_table[y - 1][x - 1] = score_table[y - 1][x - 1] + 1;
            end

            score_table[y][x - 1] = score_table[y][x - 1] + 1;

            if y < 140 then
                score_table[y + 1][x - 1] = score_table[y + 1][x - 1] + 1;
            end
        end

        if x < width then
            if y > 1 then
                score_table[y - 1][x + 1] = score_table[y - 1][x + 1] + 1;
            end

            score_table[y][x + 1] = score_table[y][x + 1] + 1;

            if y < 140 then
                score_table[y + 1][x + 1] = score_table[y + 1][x + 1] + 1;
            end
        end

        if y > 1 then
            score_table[y - 1][x] = score_table[y - 1][x] + 1;
        end

        if y < 140 then
            score_table[y + 1][x] = score_table[y + 1][x] + 1;
        end
    end

    for y = 1, height do
        for x = 1, width do
            if rolls[y][x] == 1 then
                IncrementScoreAt(access_scores, x, y);
            end
        end
    end

    for y = 1, height do
        for x = 1, width do
            if rolls[y][x] == 1 then
                if access_scores[y][x] < 4 then
                    solution = solution + 1;
                end
            end
        end
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