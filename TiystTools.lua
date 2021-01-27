
local TiystTools = LibStub("AceAddon-3.0"):NewAddon("Bunnies", "AceConsole-3.0")
local tiystLDB = LibStub("LibDataBroker-1.1"):NewDataObject("Bunnies!", {
    type = "data source",
    text = "TiystTools",
    icon = "Interface\\Icons\\INV_Chest_Cloth_17",
    OnClick = function() onButtonClick() end,
    OnTooltipShow = function(tt)
        tt:AddLine("TiystTools")
        tt:AddLine("")
        tt:AddLine("/tst (show or hide) to toggle button visibility")
        tt:AddLine("/tst vault to show the weekly Vault")
        tt:AddLine("")
    end
})
local icon = LibStub("LibDBIcon-1.0")
local dropDown = LibStub:GetLibrary("LibUIDropDownMenu-4.0")
-- local dropdown = L_Create_UIDropDownMenu("MyDropDownMenu", parent)


function TiystTools:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("wowTiystDB", { profile = { minimap = { hide = false, }, }, })
    icon:Register("TiystToolsButton", tiystLDB, self.db.profile.minimap)
end

function TiystTools:ToggleButtonVisibility() 
    self.db.profile.minimap.hide = not self.db.profile.minimap.hide 
    if self.db.profile.minimap.hide then
        icon:Hide("TiystToolsButton")
    else
        icon:Show("TiystToolsButton")
    end
end

function TiystTools:OnEnable()
    print("TiystTools enabled")
end

function TiystTools:OnDisable()
    print("TiystTools disabled")
end

function onButtonClick()
    print("Button working")
end

function OpenVault() 
    local loaded, reason = LoadAddOn("Blizzard_WeeklyRewards")
    if not loaded then
        if reason == "DISABLED" then
            print("Blizzard disabled this functionality, feels batman. Contact developer")
        elseif reason == "MISSING" then
            print("Window with vault rewards missing. AddOn is outdated or blizzard is doing some mumbo-jumbo. Contact developer")
        elseif reason == "CORRUPT" then
            print("Blizzard vault reward window is corrupted. Contact developer")
        elseif reason == "INTERFACE_VERSION" then
            print("Outdated AddOn version. Update addon or if not available contact developer.")
        end
        print("Error opening vault.")
    else
        WeeklyRewardsFrame:Show()
    end
end

function ShowHelp() 

end

local function AddonCommands(msg, editbox)
    if msg == '' then
        ShowHelp()
    elseif msg == 'show' or msg == 'hide' then
        TiystTools:ToggleButtonVisibility()
    elseif msg == 'vault' then
        OpenVault()
    elseif msg == 'help' then
        ShowHelp()
    else
        print("Unrecognised command -> " .. msg .. " not supported.")
        print("Try using '/tst help'")
    end
end

local name = UnitName("player")
message("Hello, " .. name .. "!\n Debug TiystTools working.")

-- Makes esc key close great vault window (How the f does this even work?)
tinsert(UISpecialFrames, "WeeklyRewardsFrame");
UIPanelWindows["WeeklyRewardsFrame"] = nil;

SLASH_TIYSTTOOLS1, SLASH_TIYSTTOOLS2 = '/tiysttools', '/tst'

SlashCmdList["TIYSTTOOLS"] = AddonCommands