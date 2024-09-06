-- Create a button on the minimap
local button = CreateFrame("Button", "MyMinimapButton", Minimap)
button:SetSize(32, 32)
button:SetNormalTexture("Interface\\AddOns\\wow-sample-mod\\icon")
button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
button:SetPoint("TOPLEFT", Minimap, "TOPLEFT")

-- Set the global variable to the created button
_G.MyMinimapButton = button

-- Add an event handler for the button click event
button:SetScript("OnClick", function(self, button, down)
    if button == "LeftButton" and down then
        -- Open a simple settings window when the button is clicked
        if not MySettingsFrame then
            MySettingsFrame = CreateFrame("Frame", "MySettingsFrame", UIParent, "BasicFrameTemplateWithInset")
            MySettingsFrame:SetSize(300, 200)
            MySettingsFrame:SetPoint("CENTER")
            MySettingsFrame.title = MySettingsFrame:CreateFontString(nil, "OVERLAY")
            MySettingsFrame.title:SetFontObject("GameFontHighlight")
            MySettingsFrame.title:SetPoint("LEFT", MySettingsFrame.TitleBg, "LEFT", 5, 0)
            MySettingsFrame.title:SetText("Settings")
            
            function MySettingsFrame:IsShown()
                return self.isShown or false
            end

            function MySettingsFrame:Show()
                self.isShown = true
            end
        end
        MySettingsFrame:Show()
    end
end)

function button:GetScript(scriptType)
    return self.scripts and self.scripts[scriptType] or nil
end

-- Add a new frame for "debugging" settings
if not DebugSettingsFrame then
    DebugSettingsFrame = CreateFrame("Frame", "DebugSettingsFrame", UIParent, "BasicFrameTemplateWithInset")
    DebugSettingsFrame:SetSize(300, 200)
    DebugSettingsFrame:SetPoint("CENTER")
    DebugSettingsFrame.title = DebugSettingsFrame:CreateFontString(nil, "OVERLAY")
    DebugSettingsFrame.title:SetFontObject("GameFontHighlight")
    DebugSettingsFrame.title:SetPoint("LEFT", DebugSettingsFrame.TitleBg, "LEFT", 5, 0)
    DebugSettingsFrame.title:SetText("Debugging settings")
end

-- Add a new frame for basic app information
if not AppInfoFrame then
    AppInfoFrame = CreateFrame("Frame", "AppInfoFrame", UIParent, "BasicFrameTemplateWithInset")
    AppInfoFrame:SetSize(300, 200)
    AppInfoFrame:SetPoint("CENTER")
    AppInfoFrame.title = AppInfoFrame:CreateFontString(nil, "OVERLAY")
    AppInfoFrame.title:SetFontObject("GameFontHighlight")
    AppInfoFrame.title:SetPoint("LEFT", AppInfoFrame.TitleBg, "LEFT", 5, 0)
    AppInfoFrame.title:SetText("App information")
end

-- Update the existing settings frame to follow Fluent 2 Design principles
if MySettingsFrame then
    if MySettingsFrame.title then
        MySettingsFrame.title:SetText("Settings")
    end
end

-- Create a table to store dungeon completion times and DPS
local dungeonData = {}

-- Function to update dungeon completion times and DPS
local function UpdateDungeonData(dungeonName, completionTime, dps)
    if not dungeonData[dungeonName] then
        dungeonData[dungeonName] = { fastestTime = completionTime, highestDPS = dps }
    else
        if completionTime < dungeonData[dungeonName].fastestTime then
            dungeonData[dungeonName].fastestTime = completionTime
        end
        if dps > dungeonData[dungeonName].highestDPS then
            dungeonData[dungeonName].highestDPS = dps
        end
    end
end

-- Event handler for dungeon completion
local function OnDungeonCompleted(event, dungeonName, completionTime, dps)
    UpdateDungeonData(dungeonName, completionTime, dps)
end

-- Register event for dungeon completion
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("DUNGEON_COMPLETED")
eventFrame:SetScript("OnEvent", OnDungeonCompleted)

-- Display the fastest dungeon completion times and highest DPS in the settings frame
local function DisplayDungeonData()
    if MySettingsFrame then
        local content = ""
        for dungeonName, data in pairs(dungeonData) do
            content = content .. string.format("Dungeon: %s\nFastest Time: %s\nHighest DPS: %s\n\n", dungeonName, data.fastestTime, data.highestDPS)
        end
        if not MySettingsFrame.content then
            MySettingsFrame.content = MySettingsFrame:CreateFontString(nil, "OVERLAY")
            MySettingsFrame.content:SetFontObject("GameFontHighlight")
            MySettingsFrame.content:SetPoint("TOPLEFT", MySettingsFrame, "TOPLEFT", 10, -30)
        end
        MySettingsFrame.content:SetText(content)
    end
end

-- Update the settings frame to include the new information
if MySettingsFrame then
    MySettingsFrame:SetScript("OnShow", DisplayDungeonData)
end
