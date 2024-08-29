-- Import the busted testing framework
local busted = require("busted")

-- Mock the WoW API functions used in the mod
_G.CreateFrame = function(frameType, frameName, parent, template)
    local frame = {
        SetSize = function() end,
        SetNormalTexture = function() end,
        SetHighlightTexture = function() end,
        SetPoint = function() end,
        SetScript = function(self, scriptType, scriptFunc)
            self.scripts = self.scripts or {}
            self.scripts[scriptType] = scriptFunc
        end,
        GetScript = function(self, scriptType)
            return self.scripts and self.scripts[scriptType] or nil
        end,
        CreateFontString = function() return { SetFontObject = function() end, SetPoint = function() end, SetText = function() end } end,
    }
    return frame
end

_G.Minimap = {}
_G.UIParent = {}

-- Mock MySettingsFrame with IsShown and Show methods
_G.MySettingsFrame = {
    IsShown = function(self) return self.isShown or false end,
    Show = function(self) self.isShown = true end,
}

-- Mock DebugSettingsFrame with IsShown and Show methods
_G.DebugSettingsFrame = {
    IsShown = function(self) return self.isShown or false end,
    Show = function(self) self.isShown = true end,
}

-- Mock AppInfoFrame with IsShown and Show methods
_G.AppInfoFrame = {
    IsShown = function(self) return self.isShown or false end,
    Show = function(self) self.isShown = true end,
}

-- Load the mod
dofile("wow-sample-mod/wow-sample-mod.lua")

describe("wow-sample-mod", function()
    it("should create a minimap button", function()
        assert.is_not_nil(_G.MyMinimapButton)
    end)

    it("should handle button click event", function()
        local button = _G.MyMinimapButton
        assert.is_not_nil(button)

        -- Mock the button click event
        button:GetScript("OnClick")(button, "LeftButton", true)

        assert.is_not_nil(_G.MySettingsFrame)
        assert.is_true(_G.MySettingsFrame:IsShown())
    end)

    it("should create a debugging settings frame", function()
        assert.is_not_nil(_G.DebugSettingsFrame)
    end)

    it("should create an app information frame", function()
        assert.is_not_nil(_G.AppInfoFrame)
    end)
end)
