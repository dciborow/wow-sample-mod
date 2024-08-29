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
    MySettingsFrame.title:SetText("Settings")
end
