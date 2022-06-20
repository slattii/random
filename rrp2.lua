
-- made by slatti#6944 (ignore shitty code)
local CurrentCamera = game:GetService("Workspace").CurrentCamera
local LocalMouse = game.Players.LocalPlayer:GetMouse()

function getClosestPlayerToCursor()
    local ClosestDistance, ClosestPlayer = math.huge, nil
    for _, Player in next, game:GetService("Players"):GetPlayers() do
        if Player ~= game.Players.LocalPlayer then
            local Character = Player.Character
            if Character then
                local Position, IsVisibleOnViewPort =
                    CurrentCamera:WorldToViewportPoint(Character.HumanoidRootPart.Position)
                if IsVisibleOnViewPort then
                    local Distance =
                        (Vector2.new(LocalMouse.X, LocalMouse.Y) - Vector2.new(Position.X, Position.Y)).Magnitude
                    if Distance < ClosestDistance then
                        ClosestPlayer = Player
                        ClosestDistance = Distance
                    end
                end
            end
        end
    end
    return ClosestPlayer, ClosestDistance
end

game:GetService("RunService").Stepped:Connect(
    function()
        _G.e = getClosestPlayerToCursor()
        _G.negro = tostring(_G.e)
    end
)

local gmt = getrawmetatable(game)
setreadonly(gmt, false)
oldgmt = gmt.__namecall
gmt.__namecall =
    newcclosure(
    function(self, ...)
        local args = {...}
        local method = getnamecallmethod()

        if _G.negro ~= nil and method == "FireServer" and not checkcaller() and args[1] == "Fire" then
            args[2] =
                game.Players[_G.negro].Character.HumanoidRootPart.Position +
                (game.Players[game.Players[_G.negro].Name].Character.LowerTorso.Velocity * 0.07)
            return oldgmt(self, unpack(args))
        end
        return oldgmt(self, ...)
    end
)
