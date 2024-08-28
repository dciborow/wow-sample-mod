-- Create a button on the minimap
local button = CreateFrame("Button", "MyMinimapButton", Minimap)
button:SetSize(32, 32)
button:SetNormalTexture("Interface\\AddOns\\wow-sample-mod\\icon")
button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
button:SetPoint("TOPLEFT", Minimap, "TOPLEFT")

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
        end
        MySettingsFrame:Show()
    end
end)

function button:GetScript(scriptType)
    return self.scripts and self.scripts[scriptType] or nil
end

function MySettingsFrame:IsShown()
    return self.isShown or false
end

function MySettingsFrame:Show()
    self.isShown = true
end
