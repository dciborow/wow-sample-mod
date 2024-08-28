-- Import the busted testing framework
local busted = require("busted")

-- Mock the WoW API functions used in the mod
_G.CreateFrame = function(frameType, frameName, parent, template)
    return {
        SetSize = function() end,
        SetNormalTexture = function() end,
        SetHighlightTexture = function() end,
        SetPoint = function() end,
        SetScript = function() end,
        CreateFontString = function() return { SetFontObject = function() end, SetPoint = function() end, SetText = function() end } end,
        Show = function() end,
    }
end

_G.Minimap = {}
_G.UIParent = {}

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
end)
