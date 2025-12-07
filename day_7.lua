require "utils/strings"
require "utils/sets"

local input_file, error_msg = io.open("inputs\\day7input.txt", "r");
if not input_file then
    print(error_msg);
    return;
end

local board_w = 142;
local board_h = 142;

local START = 5;
local EMPTY = 0;
local SPLITTER = 3;
local BEAM = 1;

function SolveFirstPart()
    local start_time = os.clock();
    local solution = 0;

    local board = {};
    local beams = {};

    local y = 1;
    
    for line in input_file:lines() do
        table.insert(board, {});
        local current_row = board[#board];

        local x = 1;
        for c = 1, #line do
            local char = string.sub(line, c, c);

            if char == "S" then
                table.insert(current_row, START);
                table.insert(beams, {x, y});
            elseif char == "^" then
                table.insert(current_row, SPLITTER);
            else
                table.insert(current_row, EMPTY);
            end

            x = x + 1;
        end

        y = y + 1;
    end
    input_file:seek("set", 0);

    local SimStep = function(in_board, in_beams)
        assert(type(in_board) == "table" and type(in_beams) == "table");
        local split_count = 0;

        for b = #in_beams, 1, -1 do
            local beam = in_beams[b];
            assert(beam[2] < board_h);

            local new_y = beam[2] + 1;

            if in_board[new_y][beam[1]] == SPLITTER then
                assert(beam[1] > 1 and beam[1] < board_w);

                local left_beam_x = beam[1] - 1;
                local right_beam_x = beam[1] + 1;
                local beam_moved = false;

                if in_board[new_y][left_beam_x] == EMPTY then
                    beam[1] = left_beam_x;
                    beam[2] = new_y;
                    in_board[new_y][left_beam_x] = BEAM;
                    beam_moved = true;
                end

                if in_board[new_y][right_beam_x] == EMPTY then
                    if not beam_moved then
                        beam[1] = right_beam_x;
                        beam[2] = new_y;
                        beam_moved = true;
                    else
                        table.insert(in_beams, {right_beam_x, new_y});
                    end
                    in_board[new_y][right_beam_x] = BEAM;
                end

                if not beam_moved then
                    table.remove(in_beams, b);
                end

                split_count = split_count + 1;
            elseif in_board[new_y][beam[1]] == BEAM then
                table.remove(in_beams, b);
            else
                beam[2] = new_y;
                in_board[new_y][beam[1]] = BEAM;
            end
        end

        return split_count;
    end

    local DebugDrawBeams = function(in_board, in_beams)
        assert(type(in_board) == "table" and type(in_beams) == "table");

        print("");
        print("");

        local lowest_x = 9999;
        local highest_x = 0;
        local current_y = 0;

        for b = 1, #in_beams do
            if in_beams[b][1] < lowest_x then
                lowest_x = in_beams[b][1];
            end

            if in_beams[b][1] > highest_x then
                highest_x = in_beams[b][1];
            end

            current_y = in_beams[b][2];
        end

        local from_y = current_y > 1 and current_y -1 or current_y;
        local to_y = current_y < board_h and current_y + 1 or current_y;
        local from_x = lowest_x > 2 and lowest_x - 2 or lowest_x;
        local to_x = highest_x < board_w - 2 and highest_x + 2 or highest_x;

        for y = from_y, to_y do
            local row_string = tostring(y) .. " ";
            for x = from_x, to_x do
                if in_board[y][x] == BEAM then
                    row_string = row_string .. "|";
                elseif in_board[y][x] == SPLITTER then
                    row_string = row_string .. "^";
                else
                    row_string = row_string .. ".";
                end
            end
            print(row_string);
        end

        print("");
        print("");
    end

    for i = 1, board_h - 1 do
        --DebugDrawBeams(board, beams);
        local splits = SimStep(board, beams);
        solution = solution + splits;
        --DebugDrawBeams(board, beams);
        splits = 0;
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