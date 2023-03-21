--==============================================--
---------------    [[ Notes ]]     ---------------
--==============================================--

-- Custom Bar Styles
-- https://github.com/BigWigsMods/BigWigs/wiki/Custom-Bar-Styles

--===============================================--
---------------    [[ config ]]     ---------------
--===============================================--

local glowTex = "Interface\\AddOns\\RuriWigs\\Media\\glow"
local bgTex = "Interface\\Buttons\\WHITE8X8"

local backdropBorder = {
	bgFile = bgTex,
	edgeFile = glowTex,
	tile = false, tileSize = 0, edgeSize = 3,
	insets = {left = 3, right = 3, top = 3, bottom = 3}
}

local CreateSD = function(parent, anchor, size)
	local sd = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	local framelvl = parent:GetFrameLevel()
	
	sd:ClearAllPoints()
	sd:SetPoint("TOPLEFT", anchor, -size, size)
	sd:SetPoint("BOTTOMRIGHT", anchor, size, -size)
	sd:SetFrameLevel(framelvl == 0 and 0 or framelvl-1)
	sd:SetBackdrop({
		edgeFile = glowTex,	-- 陰影邊框
		edgeSize = size or 3,		-- 邊框大小
	})
	--sd:SetBackdropColor(0, 0, 0, 1)
	--sd:SetBackdropBorderColor(0, 0, 0, 1)
	sd:SetBackdropBorderColor(.05, .05, .05, 1)
	
	return sd
end

--==================================================--
---------------    [[ Functions ]]     ---------------
--==================================================--

local function Dummy()
end

local function HookDBTCreateBar(self, ...)
	for v in self:GetBarIterator() do
		if not v.__skined then
			local frame = v.frame
			local bar = _G[frame:GetName() .. "Bar"]
			local spark = _G[frame:GetName() .. "BarSpark"]
			local icon1 = _G[frame:GetName() .. "BarIcon1"]
			local icon2 = _G[frame:GetName() .. "BarIcon2"]
			local name = _G[frame:GetName() .. "BarName"]
			local timer = _G[frame:GetName() .. "BarTimer"]

			--bar.shadow = S.MakeShadow(bar, 2)
			bar.shadow = CreateSD(bar, bar, 3)
			bar:SetStatusBarTexture(bgTex)
			bar.SetStatusBarTexture = Dummy

			icon1:SetTexCoord(0.08, 0.92, 0.08, 0.92)
			icon1.shadow = CreateSD(icon1:GetParent(), icon1, 3)
			--icon1.shadow = S.MakeTextureShadow(icon1:GetParent(), icon1, 2)

			icon2:SetTexCoord(0.08, 0.92, 0.08, 0.92)
			icon2.shadow = CreateSD(icon2:GetParent(), icon2, 3)
			--icon2.shadow = S.MakeTextureShadow(icon2:GetParent(), icon2, 2)

			v.__skined = true
		end
	end
end

local function OnPlayerLogin(self, event, ...)
	if not IsAddOnLoaded("DBM-Core") then
		return 0
	end

	hooksecurefunc(DBT, "CreateBar", HookDBTCreateBar)
end



local DBMSkin = CreateFrame("Frame")
DBMSkin:RegisterEvent("PLAYER_LOGIN")
DBMSkin:RegisterEvent("ADDON_LOADED")
DBMSkin:SetScript("OnEvent", function()
	if IsAddOnLoaded("DBM-Core") then
		OnPlayerLogin()
	end
end)