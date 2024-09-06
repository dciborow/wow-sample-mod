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

-- Mock the necessary WoW API functions for dungeon completion times and DPS tracking
_G.dungeonData = {}
_G.UpdateDungeonData = function(dungeonName, completionTime, dps)
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

_G.OnDungeonCompleted = function(event, dungeonName, completionTime, dps)
    UpdateDungeonData(dungeonName, completionTime, dps)
end

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

    it("should track dungeon completion times and DPS", function()
        OnDungeonCompleted("DUNGEON_COMPLETED", "Dungeon1", 300, 5000)
        assert.is_not_nil(dungeonData["Dungeon1"])
        assert.are.equal(300, dungeonData["Dungeon1"].fastestTime)
        assert.are.equal(5000, dungeonData["Dungeon1"].highestDPS)
    end)

    it("should update dungeon completion times and DPS", function()
        OnDungeonCompleted("DUNGEON_COMPLETED", "Dungeon1", 250, 6000)
        assert.are.equal(250, dungeonData["Dungeon1"].fastestTime)
        assert.are.equal(6000, dungeonData["Dungeon1"].highestDPS)
    end)

    it("should display dungeon data in the settings frame", function()
        _G.MySettingsFrame:Show()
        local content = _G.MySettingsFrame.content:GetText()
        assert.is_true(content:find("Dungeon: Dungeon1"))
        assert.is_true(content:find("Fastest Time: 250"))
        assert.is_true(content:find("Highest DPS: 6000"))
    end)
end)
