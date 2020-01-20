function createGame (players_ids, ranked)
    local game = {
        id = nil,
        players = {},
        ranked = ranked,
        total_balance = 0,
        is_open = true
    }
    local players_list = json.decode(openFile("./Players/players_info.json")).players_list
    for i = 1, #players_ids do 
        if findInArray(players_list, players_ids[i]) then
            local player = addPlayerToGame(players_ids[i])
            if player ~= nil then
                table.insert(game.players, player)  
            end
        end
    end
    for i = 1, #game.players do
        game.total_balance = game.total_balance + game.players[i].balance_start
    end
    if #game.players > 0 then
        game.id = newGameId()
        openFile("./Games/game_" .. game.id .. ".json", json.encode(game))
    end
end

function addPlayerToGame (player_id)
    local player = json.decode(openFile("./Players/player_" .. player_id .. ".json"))
    if player.balance <= 0 then
        return nil
    end
    local player_game = {}
    local data = nil
    local loop = true
    os.execute('cls')
    print("\nAdding player " .. player.name .. " - id: " .. player_id .. "\n")
        print("Maximum balance: $" .. player.balance)
    while loop do --balance loop
        print("\n\nBalance to enter: $")
        data = tonumber(io.read())
        if type(data) == "number" then
            if data <= player.balance then
                player_game.balance_start = data
                playerEditBalance(player_id, (data * -1), false)
                loop = false
            else
                print("\nInvalid value")
            end
        end
    end
    player_game.id = player_id
    player_game.in_game =  true
    player_game.balance_end = nil
    return player_game
end

function newGameId ()
    local data = json.decode(openFile("./Games/games_info.json"))
    data.last_id = data.last_id + 1
    local new_id = data.last_id
    openFile("./Games/games_info.json", json.encode(data))
    return new_id
end

function lastGameInfo ()
    local last_game_id = json.decode(openFile("./Games/games_info.json")).last_id
    local last_game = json.decode(openFile("./Games/game_" .. last_game_id .. ".json"))
    if last_game.is_open then
        print("Players in last game - id: " .. last_game_id)
        for i = 1, #last_game.players do
            local player = json.decode(openFile("./Players/player_" .. last_game.players[i].id .. ".json"))
            if last_game.players[i].in_game then
                print("-- " .. player.name .. ":" .. last_game.players[i].id)
            end
        end
    end
end

function gameEdit (game_id)
    local loop = true
    while loop do
        local game = json.decode(openFile("./Games/game_" .. game_id .. ".json"))
        os.execute("cls")
        gamePrint(game_id)
        print("\nType player ID to end game for the player")
            print("Type \"C\" to cancel")
        local op = string.lower(tostring(io.read()))
        if op == 'c' then
            loop = false
        else
            if findPlayerInGame(game.players, op) then
                print("\nEnter the end balance: $")
                local balance = tonumber(io.read())
                if type(balance) == "number" then
                    if balance >= 0 and balance <= game.total_balance then
                        for i = 1, #game.players do
                            if game.players[i].id == op then
                                game.players[i].balance_end = balance
                                game.players[i].in_game = false
                                openFile("./Games/game_" .. game_id .. ".json", json.encode(game))
                                if gameEnd(game_id) then
                                    loop = false
                                end
                                print("\nOK -- press enter to continue\n")
                                io.read()
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end

function gameEnd (game_id)
    local game = json.decode(openFile("./Games/game_" .. game_id .. ".json"))
    local balance_total_end = 0
    for i = 1, #game.players do
        if game.players[i].in_game then
            return nil
        end
        balance_total_end = balance_total_end + game.players[i].balance_end
    end
    if balance_total_end ~= game.total_balance then
        return nil
    end
    for i = 1, #game.players do
        local player = json.decode(openFile("./Players/player_" .. game.players[i].id .. ".json"))
        player.balance = player.balance + game.players[i].balance_end
        if game.players[i].balance_start < game.players[i].balance_end then
            player.win_balance = player.win_balance + (game.players[i].balance_end - game.players[i].balance_start)
        else
            player.lose_balance = player.lose_balance + (game.players[i].balance_start - game.players[i].balance_end)
        end
        player.win_percentage = calcWinPercentage(player.games_played, player.win_percentage, ((game.players[i].balance_end / game.players[i].balance_start) * 100))
        player.games_played = player.games_played + 1
        player.last_game = game.id
        openFile("./Players/player_" .. player.id .. ".json", json.encode(player))
    end
    game.is_open = false
    openFile("./Games/game_" .. game_id .. ".json", json.encode(game))
    print("\n\n****Game:" .. game_id .. " is closed****\n")
    return true
end

function gamePrint (game_id)
    local game = json.decode(openFile("./Games/game_" .. game_id .. ".json"))
    print("Game ID: " .. game_id .. "\n")
    print("Total balance in game: $" .. game.total_balance .. "\n\n")
    for i = 1, #game.players do
        local player = json.decode(openFile("./Players/player_" .. game.players[i].id .. ".json"))
        print(player.name .. ":" .. player.id .. " -- Start: $" .. game.players[i].balance_start .. " -- ")
        if game.players[i].in_game then
            print("In Game\n")
        else
            print("End: $" .. game.players[i].balance_end .. "\n")
        end
    end
end

function findPlayerInGame (game_players, player_id)
    for i = 1, #game_players do
        if game_players[i].id == "0000" then
            return true
        end
    end
    return false
end