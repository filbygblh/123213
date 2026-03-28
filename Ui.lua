--====================================--
-- Premium Elegant UI Library v1.0
-- Style: Elegant Light Mode
-- Features: Icons, Sounds, Color Picker, Save/Load Config, Notifications
-- Inspired by Coastified + Enhanced
--====================================--

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer

local PremiumUI = {}
PremiumUI.__index = PremiumUI

--====================================--
-- Helpers
--====================================--

local function tw(obj, props, dur, style, direction)
    TweenService:Create(obj, TweenInfo.new(dur or 0.35, style or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.Out), props):Play()
end

local function makeUICorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
end

local function makeUIStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.ApplyStrokeMode = Enum.StrokeApplyMode.Border
    s.Color = color or Color3.fromRGB(200,200,200)
    s.Thickness = thickness or 1
    s.Parent = parent
end

local function playSound(soundId, volume)
    local s = Instance.new("Sound")
    s.SoundId = soundId
    s.Volume = volume or 1
    s.Parent = workspace
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)
end

--====================================--
-- Blur Background
--====================================--

local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

local function showBlur(amount)
    tw(blur, {Size = amount or 10}, 0.35)
end

local function hideBlur()
    tw(blur, {Size = 0}, 0.35)
end

--====================================--
-- Create Window
--====================================--

function PremiumUI:CreateWindow(title, keybind)
    local self = setmetatable({}, PremiumUI)

    -- ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.ResetOnSpawn = false
    gui.Name = "PremiumUI"
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- Main Frame
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0,0,0,0)
    main.Position = UDim2.new(0.5,-300,0.5,-200)
    main.BackgroundColor3 = Color3.fromRGB(245,245,250)
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = gui
    makeUICorner(main, 12)
    makeUIStroke(main, Color3.fromRGB(210,210,220), 1)

    -- Open Animation
    showBlur(12)
    tw(main, {Size = UDim2.new(0,600,0,400)}, 0.35)

    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1,0,0,40)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 20
    titleLabel.TextColor3 = Color3.fromRGB(45,45,55)
    titleLabel.Parent = main

    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0,120,1,-40)
    sidebar.Position = UDim2.new(0,0,0,40)
    sidebar.BackgroundColor3 = Color3.fromRGB(235,235,245)
    sidebar.Parent = main
    makeUICorner(sidebar, 10)

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1,-130,1,-50)
    content.Position = UDim2.new(0,130,0,40)
    content.BackgroundTransparency = 1
    content.Parent = main

    local tabsList = {}

    --====================================--
    -- Tab Function
    --====================================--
    function tabsList:Tab(name, iconId)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1,-10,0,35)
        tabBtn.Position = UDim2.new(0,5,#sidebar:GetChildren()*40)
        tabBtn.Text = "  "..name
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.TextSize = 14
        tabBtn.TextColor3 = Color3.fromRGB(70,70,80)
        tabBtn.BackgroundColor3 = Color3.fromRGB(245,245,250)
        tabBtn.AutoButtonColor = false
        tabBtn.Parent = sidebar
        makeUICorner(tabBtn, 8)
        makeUIStroke(tabBtn, Color3.fromRGB(210,210,220), 1)

        if iconId then
            local icon = Instance.new("ImageLabel")
            icon.Size = UDim2.new(0,20,0,20)
            icon.Position = UDim2.new(0,5,0,7)
            icon.BackgroundTransparency = 1
            icon.Image = iconId
            icon.Parent = tabBtn
        end

        -- Content Frame
        local inner = Instance.new("ScrollingFrame")
        inner.Size = UDim2.new(1,0,1,0)
        inner.CanvasSize = UDim2.new(0,0,0,0)
        inner.ScrollBarThickness = 5
        inner.BackgroundTransparency = 1
        inner.Visible = false
        inner.Parent = content

        local layout = Instance.new("UIListLayout", inner)
        layout.Padding = UDim.new(0,8)
        layout.SortOrder = Enum.SortOrder.LayoutOrder

        tabBtn.MouseEnter:Connect(function()
            tw(tabBtn,{BackgroundColor3=Color3.fromRGB(230,230,240)},0.2)
            playSound("rbxassetid://9118829776",0.3)
        end)
        tabBtn.MouseLeave:Connect(function()
            tw(tabBtn,{BackgroundColor3=Color3.fromRGB(245,245,250)},0.2)
        end)

        tabBtn.MouseButton1Click:Connect(function()
            for _,v in pairs(content:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            inner.Visible = true
        end)

        -- Widgets
        local elements = {}

        function elements:Button(text, callback)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1,-20,0,35)
            b.Text = text
            b.Font = Enum.Font.Gotham
            b.TextSize = 14
            b.TextColor3 = Color3.fromRGB(45,45,55)
            b.BackgroundColor3 = Color3.fromRGB(245,245,250)
            b.Parent = inner
            makeUICorner(b, 8)
            makeUIStroke(b, Color3.fromRGB(210,210,220), 1)

            b.MouseEnter:Connect(function()
                tw(b,{BackgroundColor3=Color3.fromRGB(235,235,245)},0.2)
            end)
            b.MouseLeave:Connect(function()
                tw(b,{BackgroundColor3=Color3.fromRGB(245,245,250)},0.2)
            end)
            b.MouseButton1Click:Connect(function()
                playSound("rbxassetid://9118829776",0.5)
                callback()
            end)
        end

        function elements:Toggle(text, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1,-20,0,35)
            frame.BackgroundTransparency = 1
            frame.Parent = inner

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.7,0,1,0)
            label.Text = text
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextColor3 = Color3.fromRGB(45,45,55)
            label.BackgroundTransparency = 1
            label.Parent = frame

            local switch = Instance.new("Frame")
            switch.Size = UDim2.new(0,40,0,20)
            switch.Position = UDim2.new(1,-50,0,7)
            switch.BackgroundColor3 = Color3.fromRGB(180,180,200)
            switch.Parent = frame
            makeUICorner(switch, 12)

            local circle = Instance.new("Frame")
            circle.Size = UDim2.new(0,16,0,16)
            circle.Position = UDim2.new(0,2,0,2)
            circle.BackgroundColor3 = Color3.fromRGB(245,245,250)
            circle.Parent = switch
            makeUICorner(circle, 16)

            local state = false
            switch.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    state = not state
                    tw(circle,{Position = state and UDim2.new(1,-18,0,2) or UDim2.new(0,2,0,2)},0.2)
                    tw(switch,{BackgroundColor3 = state and Color3.fromRGB(100,180,250) or Color3.fromRGB(180,180,200)},0.2)
                    playSound("rbxassetid://9118829776",0.5)
                    callback(state)
                end
            end)
        end

        return elements
    end

    self.Gui = gui
    self.Main = main
    self.Tab = tabsList

    return self
end

return PremiumUI
