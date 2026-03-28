local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local UILib = {}

-- NOTIFICATION SYSTEM
function UILib:Notify(title, text, duration)
    local player = game.Players.LocalPlayer
    local gui = player.PlayerGui:FindFirstChild("ProUI") or Instance.new("ScreenGui", player.PlayerGui)
    gui.Name = "ProUI"

    local notif = Instance.new("Frame", gui)
    notif.Size = UDim2.new(0, 250, 0, 70)
    notif.Position = UDim2.new(1, 300, 1, -80)
    notif.BackgroundColor3 = Color3.fromRGB(30,30,30)

    local titleLbl = Instance.new("TextLabel", notif)
    titleLbl.Size = UDim2.new(1, 0, 0, 25)
    titleLbl.Text = title
    titleLbl.TextColor3 = Color3.new(1,1,1)
    titleLbl.BackgroundTransparency = 1

    local textLbl = Instance.new("TextLabel", notif)
    textLbl.Size = UDim2.new(1, 0, 1, -25)
    textLbl.Position = UDim2.new(0, 0, 0, 25)
    textLbl.Text = text
    textLbl.TextColor3 = Color3.fromRGB(200,200,200)
    textLbl.BackgroundTransparency = 1

    TweenService:Create(notif, TweenInfo.new(0.3), {
        Position = UDim2.new(1, -260, 1, -80)
    }):Play()

    task.delay(duration or 3, function()
        TweenService:Create(notif, TweenInfo.new(0.3), {
            Position = UDim2.new(1, 300, 1, -80)
        }):Play()
        task.wait(0.3)
        notif:Destroy()
    end)
end

-- MAIN WINDOW
function UILib:CreateWindow(titleText)
    local player = game.Players.LocalPlayer

    local gui = Instance.new("ScreenGui", player.PlayerGui)
    gui.Name = "ProUI"
    gui.ResetOnSpawn = false

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 550, 0, 350)
    main.Position = UDim2.new(0.5, -275, 0.5, -175)
    main.BackgroundColor3 = Color3.fromRGB(20,20,20)
    main.Active = true
    main.Draggable = true

    local top = Instance.new("TextLabel", main)
    top.Size = UDim2.new(1, 0, 0, 35)
    top.Text = titleText
    top.BackgroundColor3 = Color3.fromRGB(30,30,30)
    top.TextColor3 = Color3.new(1,1,1)

    local tabBtns = Instance.new("Frame", main)
    tabBtns.Size = UDim2.new(0, 130, 1, -35)
    tabBtns.Position = UDim2.new(0, 0, 0, 35)
    tabBtns.BackgroundColor3 = Color3.fromRGB(25,25,25)

    local container = Instance.new("Frame", main)
    container.Size = UDim2.new(1, -130, 1, -35)
    container.Position = UDim2.new(0, 130, 0, 35)
    container.BackgroundTransparency = 1

    local UIListLayout = Instance.new("UIListLayout", tabBtns)

    local window = {}

    function window:CreateTab(name)
        local btn = Instance.new("TextButton", tabBtns)
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.Text = name
        btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
        btn.TextColor3 = Color3.new(1,1,1)

        local tab = Instance.new("ScrollingFrame", container)
        tab.Size = UDim2.new(1, 0, 1, 0)
        tab.CanvasSize = UDim2.new(0,0,0,0)
        tab.ScrollBarThickness = 4
        tab.Visible = false
        tab.BackgroundTransparency = 1

        local layout = Instance.new("UIListLayout", tab)
        layout.Padding = UDim.new(0, 6)

        btn.MouseButton1Click:Connect(function()
            for _, v in pairs(container:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            tab.Visible = true
        end)

        local elements = {}

        function elements:CreateButton(text, callback)
            local b = Instance.new("TextButton", tab)
            b.Size = UDim2.new(1, -10, 0, 35)
            b.Text = text
            b.BackgroundColor3 = Color3.fromRGB(50,50,50)
            b.TextColor3 = Color3.new(1,1,1)

            b.MouseButton1Click:Connect(callback)
        end

        function elements:CreateToggle(text, callback)
            local state = false

            local b = Instance.new("TextButton", tab)
            b.Size = UDim2.new(1, -10, 0, 35)
            b.Text = text .. ": OFF"
            b.BackgroundColor3 = Color3.fromRGB(50,50,50)
            b.TextColor3 = Color3.new(1,1,1)

            b.MouseButton1Click:Connect(function()
                state = not state
                b.Text = text .. ": " .. (state and "ON" or "OFF")
                callback(state)
            end)
        end

        function elements:CreateSlider(text, min, max, default, callback)
            local value = default or min

            local frame = Instance.new("Frame", tab)
            frame.Size = UDim2.new(1, -10, 0, 50)
            frame.BackgroundTransparency = 1

            local label = Instance.new("TextLabel", frame)
            label.Size = UDim2.new(1, 0, 0, 20)
            label.Text = text .. ": " .. value
            label.TextColor3 = Color3.new(1,1,1)
            label.BackgroundTransparency = 1

            local bar = Instance.new("Frame", frame)
            bar.Size = UDim2.new(1, 0, 0, 10)
            bar.Position = UDim2.new(0, 0, 0, 30)
            bar.BackgroundColor3 = Color3.fromRGB(60,60,60)

            local fill = Instance.new("Frame", bar)
            fill.Size = UDim2.new((value-min)/(max-min), 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(0,170,255)

            bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local move
                    move = UIS.InputChanged:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseMovement then
                            local pos = (i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
                            pos = math.clamp(pos, 0, 1)
                            fill.Size = UDim2.new(pos,0,1,0)

                            value = math.floor(min + (max-min)*pos)
                            label.Text = text .. ": " .. value
                            callback(value)
                        end
                    end)

                    UIS.InputEnded:Once(function()
                        move:Disconnect()
                    end)
                end
            end)
        end

        function elements:CreateDropdown(text, options, callback)
            local current = options[1]

            local btn = Instance.new("TextButton", tab)
            btn.Size = UDim2.new(1, -10, 0, 35)
            btn.Text = text .. ": " .. current
            btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
            btn.TextColor3 = Color3.new(1,1,1)

            btn.MouseButton1Click:Connect(function()
                current = options[math.random(1,#options)]
                btn.Text = text .. ": " .. current
                callback(current)
            end)
        end

        function elements:CreateKeybind(text, key, callback)
            local current = key

            local btn = Instance.new("TextButton", tab)
            btn.Size = UDim2.new(1, -10, 0, 35)
            btn.Text = text .. ": " .. current.Name
            btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
            btn.TextColor3 = Color3.new(1,1,1)

            UIS.InputBegan:Connect(function(input, gpe)
                if not gpe and input.KeyCode == current then
                    callback()
                end
            end)
        end

        return elements
    end

    return window
end

return UILib
