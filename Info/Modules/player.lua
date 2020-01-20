function playerEditBalance (player_id, value, override)
    local player = json.decode(openFile("./Players/player_" .. player_id .. ".json"))
    if not override then
        player.balance = player.balance + value
    else
        player.balance = value
    end
    openFile("./Players/player_" .. player_id .. ".json", json.encode(player))
end

function calcWinPercentage (games_played, win_percentage, new_win_percentage)
    return ((games_played * win_percentage) + new_win_percentage) / (games_played + 1)
end

function validPlayerId (data)
    local id = tostring(data)
    if type(id) == "string" then
        if string.len(id) == 4 then
            return true
        end
    end
    return false
end

function playerCreate ()
    local players_info = json.decode(openFile("./Players/players_info.json"))
        local loop = true
        os.execute('cls')
        while loop do
            print("Enter the new ID: ")
            local id = string.lower(tostring(io.read()))
            if id == 'e' then
                loop = false
            else
                if validPlayerId(id) then
                    if not findInArray(players_info.players_list, id) then
                        print("\nEnter the player name: ")
                        local name = tostring(io.read())
                        local player = {
                            id = id,
                            name = name,
                            balance = 0,
                            win_balance = 0,
                            lose_balance = 0,
                            win_percentage = 0,
                            games_played = 0,
                            in_game = false,
                            last_game = nil
                        }                  
                        openFile("Players/player_" .. player.id .. ".json", json.encode(player))
                        playerAddToList(player.id)
                        loop = false
                        print("\nPlayer " .. player.name .. ":" .. player.id .. " created\n\nPress enter to continue")
                        io.read()         
                    else
                        print("\nID already registred\n")
                    end
                else
                    print("\nInvalid id\n")
                end
            end
        end
end

function playerAddToList (player_id)
    local players_info = json.decode(openFile("./Players/players_info.json"))
    table.insert(players_info.players_list, player_id)
    openFile("./Players/players_info.json", json.encode(players_info))
end

function addBalanceToPlayer ()
    os.execute("cls")
    local players_list = json.decode(openFile("./Players/players_info.json")).players_list
    local loop = true
    while loop do
        print("Enter player id to add balance")
        local id = string.lower(tostring(io.read()))
        if id == "e" then
            loop = false
        else
            if findInArray(players_list, id) then
                print("\nEnter the balance to add")
                local balance = tonumber(io.read())
                if type(balance) == "number" then
                    loop = false
                    playerEditBalance(id, balance, false)
                    print("Balance added\nPress enter to continue")
                    io.read()
                end
            end
        end
    end
end