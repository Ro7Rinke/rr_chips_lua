require("Modules.file")
require("Modules.game")
require("Modules.fun")
require("Modules.player")
json = require("Modules.json")

function main ()
    local main_loop = true
    while main_loop do
        local op = nil
        os.execute('cls')
        lastGameInfo()
        print("\nType \"C\" to create a new game")
            print("Type \"G\" to edit a game")
                print("Type \"P\" to create a new player")
                    print("Type \"A\" to add balance to a player")
                        print("Type \"E\" to exit")
        op = string.lower(tostring(io.read()))
        if op == 'c' then
            local players_ids = {}
            local add_more_players = true
            local op_create_game = nil
            local exit = false
            while add_more_players do
                os.execute('cls')
                print("\nEnter the player id to add\n")
                    print("Enter \"Y\" or \"OK\" to confirm\n")
                        print("Enter \"E\" to cancel")
                op_create_game = string.lower(tostring(io.read()))
                if op_create_game == 'e' then
                    add_more_players = false
                    exit = true
                else
                    if op_create_game == 'y' or op_create_game == 'ok' then
                        add_more_players = false
                    else
                        table.insert(players_ids, op_create_game)
                    end
                end
            end
            if not exit then
                createGame(players_ids, true)
            end
        end
        if op == 'g' then
            local game_last_id = json.decode(openFile("./Games/games_info.json")).last_id
            local loop = true
            while loop do
                os.execute('cls')
                print("Enter the game ID: ")
                local game_id = tonumber(io.read())
                if type(game_id) == "number" then
                    if game_id >= 0 and game_id <= game_last_id then
                        gameEdit(game_id)
                        loop = false
                    end
                end
            end
        end
        if op == 'p' then
            playerCreate()
        end
        if op == 'a' then
           addBalanceToPlayer()
        end
        if op == 'e' then
            os.exit()
        end
    end
end

main()