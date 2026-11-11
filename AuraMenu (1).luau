local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local SOURCE_URL = "https://raw.githubusercontent.com/goostyor-png/AuraMenu/refs/heads/main/AuraMenu_fixed%20(1).lua"
local KEY_LINK = "https://discord.gg/FmzE9G7Ry"
local INVITE_CODE = "FmzE9G7Ry"
local VALID_KEY = "key-lay4shx0"

local ACCENT = Color3.fromRGB(138, 92, 255)
local ACCENT2 = Color3.fromRGB(70, 170, 255)
local GOOD = Color3.fromRGB(70, 214, 140)
local GOOD2 = Color3.fromRGB(60, 190, 190)
local BAD = Color3.fromRGB(255, 85, 105)
local WHITE = Color3.fromRGB(255, 255, 255)
local TEXT = Color3.fromRGB(240, 240, 250)
local MUTED = Color3.fromRGB(150, 150, 178)
local DIM = Color3.fromRGB(100, 100, 128)
local CARD = Color3.fromRGB(19, 19, 28)
local FIELD = Color3.fromRGB(26, 26, 38)
local LINE = Color3.fromRGB(52, 52, 74)

local sourceState = { ready = false, source = nil }

local function fetchSource()
    local ok, result = pcall(function()
        return game:HttpGet(SOURCE_URL)
    end)
    if ok and type(result) == "string" then
        sourceState.source = result
        return true
    end
    return false
end

task.spawn(function()
    fetchSource()
    sourceState.ready = true
end)

local function buildMenu()
    if not sourceState.source then
        if not fetchSource() then
            return nil, "Failed to download the menu. Check your connection."
        end
    end

    local source = sourceState.source

    local introStartTag = "local function showAuraIntro()"
    local introCallTag = "\nshowAuraIntro()"

    local introStart = source:find(introStartTag, 1, true)
    if not introStart then
        return nil, "Menu structure changed (splash not found)."
    end

    local introCall = source:find(introCallTag, introStart, true)
    if not introCall then
        return nil, "Menu structure changed (splash call not found)."
    end

    local afterIntroCall = source:find("\n", introCall + #introCallTag, true)
    if not afterIntroCall then
        return nil, "Menu structure changed (splash end not found)."
    end

    source = source:sub(1, introStart - 1) .. source:sub(afterIntroCall + 1)

    local compiled, compileError = loadstring(source)
    if not compiled then
        return nil, "Menu failed to compile: " .. tostring(compileError)
    end

    return compiled
end

local function new(class, props, children)
    local inst = Instance.new(class)
    local parent
    for key, value in pairs(props or {}) do
        if key == "Parent" then
            parent = value
        else
            inst[key] = value
        end
    end
    for _, child in ipairs(children or {}) do
        child.Parent = inst
    end
    if parent then
        inst.Parent = parent
    end
    return inst
end

local function tween(inst, time, props, style, direction)
    local info = TweenInfo.new(time, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
    local t = TweenService:Create(inst, info, props)
    t:Play()
    return t
end

local function corner(radius)
    return new("UICorner", { CornerRadius = UDim.new(0, radius) })
end

local function round()
    return new("UICorner", { CornerRadius = UDim.new(1, 0) })
end

local function outline(color, thickness, transparency)
    return new("UIStroke", {
        Color = color,
        Thickness = thickness,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })
end

local function gradient(c1, c2, rotation)
    return new("UIGradient", {
        Color = ColorSequence.new(c1, c2),
        Rotation = rotation or 0,
    })
end

local gui = new("ScreenGui", {
    Name = "AuraLoader",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 999999,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

local mounted = pcall(function()
    gui.Parent = (gethui and gethui()) or CoreGui
end)
if not mounted or not gui.Parent then
    gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

local alive = true
local menuFunction = nil
local finished = Instance.new("BindableEvent")
local connections = {}

gui.Destroying:Connect(function()
    alive = false
    for _, connection in ipairs(connections) do
        connection:Disconnect()
    end
    finished:Fire()
end)

local backdrop = new("Frame", {
    Parent = gui,
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = WHITE,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Active = true,
})

local backdropGradient = new("UIGradient", {
    Parent = backdrop,
    Rotation = 35,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 8, 14)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(17, 12, 32)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 13, 26)),
    }),
})

local particleLayer = new("Frame", {
    Parent = backdrop,
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
})

local particles = {}

for i = 1, 24 do
    local size = math.random(2, 5)
    local particle = new("Frame", {
        Parent = particleLayer,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(size, size),
        BackgroundColor3 = (i % 2 == 0) and ACCENT or ACCENT2,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromScale(math.random(), 1.1),
    }, { round() })
    table.insert(particles, particle)

    task.spawn(function()
        task.wait(math.random() * 4)
        while alive do
            local x = math.random()
            local duration = math.random(70, 130) / 10
            particle.Position = UDim2.fromScale(x, 1.05)
            particle.BackgroundTransparency = 1
            tween(particle, duration, {
                Position = UDim2.fromScale(x + (math.random() - 0.5) * 0.18, -0.05),
            }, Enum.EasingStyle.Linear)
            tween(particle, duration * 0.25, {
                BackgroundTransparency = math.random(35, 75) / 100,
            }, Enum.EasingStyle.Sine)
            task.wait(duration * 0.75)
            if not alive then
                break
            end
            tween(particle, duration * 0.25, { BackgroundTransparency = 1 }, Enum.EasingStyle.Sine)
            task.wait(duration * 0.25)
        end
    end)
end

local stage = new("Frame", {
    Parent = backdrop,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(640, 460),
    BackgroundTransparency = 1,
})

local stageScale = new("UIScale", { Parent = stage })

local function updateScale()
    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
    stageScale.Scale = math.clamp(math.min(viewport.X / 680, viewport.Y / 500), 0.5, 1.3)
end

updateScale()

if workspace.CurrentCamera then
    table.insert(connections, workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale))
end

local loadGroup = new("CanvasGroup", {
    Parent = stage,
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    GroupTransparency = 1,
})

local ringHolder = new("Frame", {
    Parent = loadGroup,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0, 112),
    Size = UDim2.fromOffset(140, 140),
    BackgroundTransparency = 1,
})

local ringScale = new("UIScale", { Parent = ringHolder, Scale = 0.5 })

local function makeRing(size, thickness, c1, c2)
    local frame = new("Frame", {
        Parent = ringHolder,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(size, size),
        BackgroundTransparency = 1,
    }, { round() })
    local stroke = outline(WHITE, thickness)
    stroke.Parent = frame
    local grad = new("UIGradient", {
        Parent = stroke,
        Color = ColorSequence.new(c1, c2),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.65, 1),
            NumberSequenceKeypoint.new(1, 1),
        }),
    })
    return frame, grad
end

local trackRing = new("Frame", {
    Parent = ringHolder,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(104, 104),
    BackgroundTransparency = 1,
}, { round(), outline(WHITE, 3, 0.9) })

local _, innerGradient = makeRing(104, 3, ACCENT, ACCENT2)
local _, outerGradient = makeRing(132, 1.5, ACCENT2, ACCENT)

local coreLetter = new("TextLabel", {
    Parent = ringHolder,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(60, 60),
    BackgroundTransparency = 1,
    Text = "A",
    Font = Enum.Font.GothamBlack,
    TextSize = 42,
    TextColor3 = WHITE,
}, {
    gradient(ACCENT, ACCENT2, 90),
})

local coreScale = new("UIScale", { Parent = coreLetter })

TweenService:Create(coreScale, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
    Scale = 1.12,
}):Play()

local logo = new("Frame", {
    Parent = loadGroup,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 200),
    Size = UDim2.fromOffset(300, 50),
    BackgroundTransparency = 1,
}, {
    new("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }),
})

local letters = {}

for index, character in ipairs({ "A", "U", "R", "A" }) do
    local label = new("TextLabel", {
        Parent = logo,
        LayoutOrder = index,
        Size = UDim2.fromOffset(34, 50),
        BackgroundTransparency = 1,
        Text = character,
        Font = Enum.Font.GothamBlack,
        TextSize = 40,
        TextColor3 = WHITE,
        TextTransparency = 1,
    }, {
        gradient(WHITE, Color3.fromRGB(184, 164, 255), 90),
    })
    local scale = new("UIScale", { Parent = label, Scale = 0.4 })
    table.insert(letters, { label = label, scale = scale })
end

local subtitle = new("TextLabel", {
    Parent = loadGroup,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 254),
    Size = UDim2.fromOffset(300, 18),
    BackgroundTransparency = 1,
    Text = "M  E  N  U",
    Font = Enum.Font.GothamMedium,
    TextSize = 13,
    TextColor3 = MUTED,
    TextTransparency = 1,
})

local track = new("Frame", {
    Parent = loadGroup,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 308),
    Size = UDim2.fromOffset(320, 6),
    BackgroundColor3 = Color3.fromRGB(30, 30, 44),
    BorderSizePixel = 0,
}, { round() })

local fill = new("Frame", {
    Parent = track,
    Size = UDim2.fromScale(0, 1),
    BackgroundColor3 = WHITE,
    BorderSizePixel = 0,
}, { round(), gradient(ACCENT, ACCENT2, 0) })

local tip = new("Frame", {
    Parent = fill,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(1, 0.5),
    Size = UDim2.fromOffset(16, 16),
    BackgroundColor3 = ACCENT2,
    BackgroundTransparency = 0.65,
    BorderSizePixel = 0,
}, { round() })

local infoRow = new("Frame", {
    Parent = loadGroup,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 324),
    Size = UDim2.fromOffset(320, 20),
    BackgroundTransparency = 1,
})

local statusLabel = new("TextLabel", {
    Parent = infoRow,
    Size = UDim2.fromScale(0.78, 1),
    BackgroundTransparency = 1,
    Text = "Starting",
    Font = Enum.Font.GothamMedium,
    TextSize = 12,
    TextColor3 = MUTED,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local percentLabel = new("TextLabel", {
    Parent = infoRow,
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.fromScale(1, 0),
    Size = UDim2.fromScale(0.22, 1),
    BackgroundTransparency = 1,
    Text = "0%",
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    TextColor3 = TEXT,
    TextXAlignment = Enum.TextXAlignment.Right,
})

local tips = {
    "Join our Discord for updates and support",
    "Preparing a smooth experience",
    "Good things take just a moment",
}

local tipLabel = new("TextLabel", {
    Parent = loadGroup,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 410),
    Size = UDim2.fromOffset(460, 18),
    BackgroundTransparency = 1,
    Text = tips[math.random(1, #tips)],
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextColor3 = DIM,
    TextTransparency = 1,
})

local progress = Instance.new("NumberValue")

progress.Changed:Connect(function(value)
    fill.Size = UDim2.fromScale(math.clamp(value, 0, 1), 1)
    percentLabel.Text = string.format("%d%%", math.floor(value * 100 + 0.5))
end)

local function setStatus(text)
    statusLabel.Text = text
    statusLabel.TextTransparency = 0.7
    tween(statusLabel, 0.35, { TextTransparency = 0 })
end

local keyGroup = new("CanvasGroup", {
    Parent = stage,
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    GroupTransparency = 1,
    Visible = false,
})

local card = new("Frame", {
    Parent = keyGroup,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(400, 330),
    BackgroundColor3 = WHITE,
    BorderSizePixel = 0,
}, {
    corner(18),
    new("UIGradient", {
        Rotation = 90,
        Color = ColorSequence.new(Color3.fromRGB(25, 23, 38), Color3.fromRGB(15, 15, 23)),
    }),
})

local cardScale = new("UIScale", { Parent = card })
local cardStroke = outline(WHITE, 1.5)
cardStroke.Parent = card

local cardStrokeGradient = new("UIGradient", {
    Parent = cardStroke,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, ACCENT),
        ColorSequenceKeypoint.new(0.5, ACCENT2),
        ColorSequenceKeypoint.new(1, ACCENT),
    }),
})

local badge = new("Frame", {
    Parent = card,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 20),
    Size = UDim2.fromOffset(42, 42),
    BackgroundColor3 = WHITE,
    BorderSizePixel = 0,
}, {
    corner(12),
    gradient(ACCENT, ACCENT2, 45),
    new("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "A",
        Font = Enum.Font.GothamBlack,
        TextSize = 22,
        TextColor3 = WHITE,
    }),
})

local badgeScale = new("UIScale", { Parent = badge })

TweenService:Create(badgeScale, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
    Scale = 1.08,
}):Play()

local title = new("TextLabel", {
    Parent = card,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 70),
    Size = UDim2.new(1, -56, 0, 28),
    BackgroundTransparency = 1,
    Text = "Key System",
    Font = Enum.Font.GothamBold,
    TextSize = 24,
    TextColor3 = TEXT,
    MaxVisibleGraphemes = 0,
})

local cardSubtitle = new("TextLabel", {
    Parent = card,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 100),
    Size = UDim2.new(1, -56, 0, 18),
    BackgroundTransparency = 1,
    Text = "Enter your key to unlock Aura Menu",
    Font = Enum.Font.Gotham,
    TextSize = 13,
    TextColor3 = MUTED,
    TextTransparency = 1,
})

local inputFrame = new("Frame", {
    Parent = card,
    Position = UDim2.new(0, 28, 0, 134),
    Size = UDim2.new(1, -56, 0, 44),
    BackgroundColor3 = FIELD,
    BorderSizePixel = 0,
}, { corner(10) })

local inputStroke = outline(LINE, 1.5)
inputStroke.Parent = inputFrame

local keyBox = new("TextBox", {
    Parent = inputFrame,
    Position = UDim2.fromOffset(14, 0),
    Size = UDim2.new(1, -28, 1, 0),
    BackgroundTransparency = 1,
    Text = "",
    PlaceholderText = "key-xxxxxxxx",
    PlaceholderColor3 = DIM,
    TextColor3 = TEXT,
    Font = Enum.Font.GothamMedium,
    TextSize = 15,
    ClearTextOnFocus = false,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local statusKey = new("TextLabel", {
    Parent = card,
    Position = UDim2.new(0, 28, 0, 184),
    Size = UDim2.new(1, -56, 0, 18),
    BackgroundTransparency = 1,
    Text = "",
    Font = Enum.Font.GothamMedium,
    TextSize = 12,
    TextColor3 = MUTED,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local function setKeyStatus(text, color)
    statusKey.Text = text
    statusKey.TextColor3 = color or MUTED
    statusKey.TextTransparency = 1
    tween(statusKey, 0.3, { TextTransparency = 0 })
end

local function makeButton(parent, text, position, size, primary)
    local button = new("TextButton", {
        Parent = parent,
        Position = position,
        Size = size,
        BackgroundColor3 = primary and WHITE or Color3.fromRGB(30, 30, 44),
        AutoButtonColor = false,
        Text = "",
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, { corner(10) })

    local scale = new("UIScale", { Parent = button })
    local label = new("TextLabel", {
        Parent = button,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = text,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextColor3 = WHITE,
        ZIndex = 3,
    })

    local grad, stroke

    if primary then
        grad = gradient(ACCENT, ACCENT2, 0)
        grad.Parent = button

        local shine = new("Frame", {
            Parent = button,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(-0.3, 0.5),
            Size = UDim2.fromOffset(46, 120),
            Rotation = 20,
            BackgroundColor3 = WHITE,
            BorderSizePixel = 0,
            ZIndex = 2,
        }, {
            new("UIGradient", {
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.5, 0.78),
                    NumberSequenceKeypoint.new(1, 1),
                }),
            }),
        })

        task.spawn(function()
            task.wait(1)
            while alive do
                shine.Position = UDim2.fromScale(-0.3, 0.5)
                tween(shine, 0.9, { Position = UDim2.fromScale(1.3, 0.5) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                task.wait(3)
            end
        end)
    else
        stroke = outline(LINE, 1.5)
        stroke.Parent = button
    end

    button.MouseEnter:Connect(function()
        tween(scale, 0.2, { Scale = 1.03 })
        if not primary then
            tween(button, 0.2, { BackgroundColor3 = Color3.fromRGB(40, 38, 60) })
            tween(stroke, 0.2, { Color = ACCENT })
        end
    end)

    button.MouseLeave:Connect(function()
        tween(scale, 0.25, { Scale = 1 })
        if not primary then
            tween(button, 0.25, { BackgroundColor3 = Color3.fromRGB(30, 30, 44) })
            tween(stroke, 0.25, { Color = LINE })
        end
    end)

    button.MouseButton1Down:Connect(function()
        tween(scale, 0.1, { Scale = 0.96 })
    end)

    button.MouseButton1Up:Connect(function()
        tween(scale, 0.2, { Scale = 1.03 }, Enum.EasingStyle.Back)
    end)

    return button, label, grad
end

local verifyButton, verifyLabel, verifyGradient = makeButton(
    card, "Verify Key", UDim2.new(0, 28, 0, 212), UDim2.new(1, -56, 0, 44), true
)

local getKeyButton, getKeyLabel = makeButton(
    card, "Get Key  •  Discord", UDim2.new(0, 28, 0, 266), UDim2.new(1, -56, 0, 40), false
)

local closeButton = new("TextButton", {
    Parent = card,
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -14, 0, 14),
    Size = UDim2.fromOffset(26, 26),
    BackgroundTransparency = 1,
    Text = "X",
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    TextColor3 = DIM,
    AutoButtonColor = false,
})

closeButton.MouseEnter:Connect(function()
    tween(closeButton, 0.2, { TextColor3 = BAD })
end)

closeButton.MouseLeave:Connect(function()
    tween(closeButton, 0.2, { TextColor3 = DIM })
end)

local footer = new("TextLabel", {
    Parent = keyGroup,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 412),
    Size = UDim2.fromOffset(400, 18),
    BackgroundTransparency = 1,
    Text = "The key is posted in our Discord server",
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextColor3 = DIM,
})

table.insert(connections, RunService.RenderStepped:Connect(function(dt)
    innerGradient.Rotation = (innerGradient.Rotation + dt * 320) % 360
    outerGradient.Rotation = (outerGradient.Rotation - dt * 140) % 360
    cardStrokeGradient.Rotation = (cardStrokeGradient.Rotation + dt * 60) % 360
    backdropGradient.Rotation = 35 + math.sin(os.clock() * 0.25) * 12
end))

local function shake(object, base)
    task.spawn(function()
        for _, dx in ipairs({ -12, 12, -8, 8, -4, 4, 0 }) do
            tween(object, 0.045, { Position = base + UDim2.fromOffset(dx, 0) }, Enum.EasingStyle.Sine)
            task.wait(0.045)
        end
    end)
end

local cardBase = UDim2.fromScale(0.5, 0.5)
local busy = false
local copying = false
local submit

keyBox.Focused:Connect(function()
    tween(inputStroke, 0.25, { Color = ACCENT })
    tween(inputFrame, 0.25, { BackgroundColor3 = Color3.fromRGB(31, 29, 46) })
end)

keyBox.FocusLost:Connect(function(enterPressed)
    tween(inputStroke, 0.3, { Color = LINE })
    tween(inputFrame, 0.3, { BackgroundColor3 = FIELD })
    if enterPressed then
        task.spawn(submit)
    end
end)

local function closeGui(result)
    if not alive then
        return
    end
    alive = false
    menuFunction = result
    for _, particle in ipairs(particles) do
        tween(particle, 0.6, { BackgroundTransparency = 1 })
    end
    tween(keyGroup, 0.55, { GroupTransparency = 1 })
    tween(cardScale, 0.55, { Scale = 1.06 })
    task.wait(0.35)
    tween(backdrop, 0.45, { BackgroundTransparency = 1 })
    task.wait(0.5)
    gui:Destroy()
end

submit = function()
    if busy then
        return
    end

    local entered = (keyBox.Text:gsub("%s+", "")):lower()

    if entered == "" then
        tween(inputStroke, 0.2, { Color = BAD })
        setKeyStatus("Please enter your key first", BAD)
        shake(card, cardBase)
        task.delay(0.8, function()
            if not keyBox:IsFocused() then
                tween(inputStroke, 0.3, { Color = LINE })
            end
        end)
        return
    end

    busy = true
    setKeyStatus("", MUTED)

    for i = 1, 6 do
        verifyLabel.Text = "Checking" .. string.rep(".", i % 4)
        task.wait(0.15)
    end

    if entered ~= VALID_KEY:lower() then
        verifyLabel.Text = "Verify Key"
        tween(inputStroke, 0.2, { Color = BAD })
        setKeyStatus("Invalid key. Grab a valid one in our Discord", BAD)
        shake(card, cardBase)
        task.delay(1, function()
            if not keyBox:IsFocused() then
                tween(inputStroke, 0.3, { Color = LINE })
            end
        end)
        busy = false
        return
    end

    verifyLabel.Text = "Access Granted"
    verifyGradient.Color = ColorSequence.new(GOOD, GOOD2)
    tween(inputStroke, 0.3, { Color = GOOD })
    setKeyStatus("Key accepted. Loading menu...", GOOD)
    tween(cardScale, 0.3, { Scale = 1.03 }, Enum.EasingStyle.Back)
    task.wait(0.15)
    tween(cardScale, 0.3, { Scale = 1 })

    local waited = 0
    while not sourceState.ready and waited < 15 do
        task.wait(0.1)
        waited += 0.1
    end

    local compiled, failure = buildMenu()

    if not compiled then
        verifyLabel.Text = "Verify Key"
        verifyGradient.Color = ColorSequence.new(ACCENT, ACCENT2)
        tween(inputStroke, 0.2, { Color = BAD })
        setKeyStatus(failure, BAD)
        shake(card, cardBase)
        busy = false
        return
    end

    task.wait(0.4)
    closeGui(compiled)
end

verifyButton.MouseButton1Click:Connect(submit)

getKeyButton.MouseButton1Click:Connect(function()
    local copy = setclipboard or toclipboard or (syn and syn.write_clipboard)
    local copied = false

    if copy then
        copied = pcall(copy, KEY_LINK)
    end

    task.spawn(function()
        pcall(function()
            request({
                Url = "http://127.0.0.1:6463/rpc?v=1",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["Origin"] = "https://discord.com",
                },
                Body = HttpService:JSONEncode({
                    cmd = "INVITE_BROWSER",
                    args = { code = INVITE_CODE },
                    nonce = HttpService:GenerateGUID(false),
                }),
            })
        end)
    end)

    if copied then
        setKeyStatus("Discord link copied to clipboard", GOOD)
    else
        setKeyStatus("Open in browser: " .. KEY_LINK, ACCENT2)
    end

    if not copying then
        copying = true
        getKeyLabel.Text = copied and "Link Copied!" or "Link Shown Above"
        getKeyLabel.TextColor3 = copied and GOOD or ACCENT2
        task.delay(1.8, function()
            getKeyLabel.Text = "Get Key  •  Discord"
            getKeyLabel.TextColor3 = WHITE
            copying = false
        end)
    end
end)

closeButton.MouseButton1Click:Connect(function()
    closeGui(nil)
end)

local function runLoading()
    tween(backdrop, 0.7, { BackgroundTransparency = 0 })
    task.wait(0.4)

    tween(loadGroup, 0.7, { GroupTransparency = 0 })
    tween(ringScale, 0.9, { Scale = 1 }, Enum.EasingStyle.Back)
    task.wait(0.35)

    for index, letter in ipairs(letters) do
        task.delay((index - 1) * 0.12, function()
            tween(letter.label, 0.6, { TextTransparency = 0 })
            tween(letter.scale, 0.7, { Scale = 1 }, Enum.EasingStyle.Back)
        end)
    end

    task.wait(0.6)
    tween(subtitle, 0.6, { TextTransparency = 0 })
    tween(tipLabel, 0.8, { TextTransparency = 0 })
    task.wait(0.4)

    local stages = {
        { "Initializing environment", 0.16, 0.8 },
        { "Checking executor", 0.32, 0.7 },
        { "Loading modules", 0.58, 1.0 },
        { "Fetching menu data", 0.82, 0.9 },
        { "Finalizing", 1, 0.8 },
    }

    for _, entry in ipairs(stages) do
        if not alive then
            return false
        end
        setStatus(entry[1])
        tween(progress, entry[3], { Value = entry[2] }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(entry[3] + 0.15)
    end

    setStatus("Ready")
    tween(tip, 0.3, { Size = UDim2.fromOffset(28, 28), BackgroundTransparency = 0.8 })
    task.wait(0.5)

    tween(loadGroup, 0.6, { GroupTransparency = 1, Position = UDim2.fromOffset(0, -24) })
    tween(ringScale, 0.6, { Scale = 1.2 })
    task.wait(0.7)
    loadGroup.Visible = false
    return true
end

local function showKey()
    keyGroup.Visible = true
    cardScale.Scale = 0.9
    card.Position = UDim2.new(0.5, 0, 0.5, 28)

    tween(keyGroup, 0.7, { GroupTransparency = 0 })
    tween(card, 0.85, { Position = cardBase }, Enum.EasingStyle.Back)
    tween(cardScale, 0.85, { Scale = 1 }, Enum.EasingStyle.Back)

    task.wait(0.35)

    local full = title.Text
    for i = 1, #full do
        if not alive then
            return
        end
        title.MaxVisibleGraphemes = i
        task.wait(0.045)
    end
    title.MaxVisibleGraphemes = -1

    tween(cardSubtitle, 0.6, { TextTransparency = 0 })
end

task.spawn(function()
    if runLoading() and alive then
        showKey()
    end
end)

finished.Event:Wait()

if menuFunction then
    return menuFunction()
end
