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
local iconSize = 24

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
	sd:SetBackdropBorderColor(0, 0, 0, 1)
	
	return sd
end

--==================================================--
---------------    [[ Functions ]]     ---------------
--==================================================--

local Dummy = function() end

local function SkinBars(self)
	for bar in self:GetBarIterator() do
		if not bar.skined then
			bar.ApplyStyle = function()
				local frame = bar.frame
				local tbar = _G[frame:GetName().."Bar"]
				local spark = _G[frame:GetName().."BarSpark"]
				local icon1 = _G[frame:GetName().."BarIcon1"]
				local icon2 = _G[frame:GetName().."BarIcon2"]
				local name = _G[frame:GetName().."BarName"]
				local timer = _G[frame:GetName().."BarTimer"]

				if icon1.overlay then
					icon1.overlay = _G[icon1.overlay:GetName()]
				else
					icon1.overlay = CreateFrame("Frame", "$parentIcon1Overlay", tbar)
					icon1.overlay:SetFrameStrata("BACKGROUND")
					icon1.overlay:SetWidth(iconSize)
					icon1.overlay:SetHeight(iconSize)
					icon1.overlay:SetPoint("BOTTOMRIGHT", tbar, "BOTTOMLEFT", -5, -2)
				end

				if icon2.overlay then
					icon2.overlay = _G[icon2.overlay:GetName()]
				else
					icon2.overlay = CreateFrame("Frame", "$parentIcon2Overlay", tbar)
					icon2.overlay:SetWidth(iconSize)
					icon2.overlay:SetHeight(iconSize)
					icon2.overlay:SetFrameStrata("BACKGROUND")
					icon2.overlay:SetPoint("BOTTOMLEFT", tbar, "BOTTOMRIGHT", 5, -2)
				end

				if bar.enlarged then
					frame:SetWidth(DBT.Options.HugeWidth)
					tbar:SetWidth(DBT.Options.HugeWidth)
				else
					frame:SetWidth(DBT.Options.Width)
					tbar:SetWidth(DBT.Options.Width)
				end

				if not frame.styled then
					frame:SetScale(1)
					frame:SetHeight(iconSize/2)
					frame.styled = true
				end

				if not spark.killed then
					spark:SetAlpha(0)
					spark:SetTexture(nil)
					spark.killed = true
				end

				if not icon1.styled then
					icon1:SetTexCoord(0.1, 0.9, 0.1, 0.9)
					icon1:ClearAllPoints()
					icon1.Shadow = CreateSD(icon1.overlay, icon1, 3)
					icon1:SetPoint("TOPLEFT", icon1.overlay, 2, -2)
					icon1:SetPoint("BOTTOMRIGHT", icon1.overlay, -2, 2)
					icon1.styled = true
				end

				if not icon2.styled then
					icon2:SetTexCoord(0.1, 0.9, 0.1, 0.9)
					icon2.Shadow = CreateSD(icon2.overlay, icon2, 3)
					icon2:ClearAllPoints()
					icon2:SetPoint("TOPLEFT", icon2.overlay, 2, -2)
					icon2:SetPoint("BOTTOMRIGHT", icon2.overlay, -2, 2)
					icon2.styled = true
				end

				if not tbar.styled then
					tbar.shadow = CreateSD(tbar, tbar, 3)
					tbar:SetStatusBarTexture(bgTex)
					tbar.SetStatusBarTexture = Dummy
					tbar:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
					tbar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
					tbar.styled = true
				end

				if not name.styled then
					name:ClearAllPoints()
					name:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 4, -iconSize/4+2)
					name:SetWidth(165)
					name:SetHeight(8)
					name:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
					name:SetShadowOffset(0, 0)
					name:SetJustifyH("LEFT")
					name.SetFont = Dummy
					name.styled = true
				end

				if not timer.styled then
					timer:ClearAllPoints()
					timer:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -2, -iconSize/4+2)
					timer:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
					timer:SetShadowOffset(0, 0)
					timer:SetJustifyH("RIGHT")
					timer.SetFont = Dummy
					timer.styled = true
				end

				if DBT.Options.IconLeft then icon1:Show() icon1.overlay:Show() else icon1:Hide() icon1.overlay:Hide() end
				if DBT.Options.IconRight then icon2:Show() icon2.overlay:Show() else icon2:Hide() icon2.overlay:Hide() end
				
				tbar:SetAlpha(1)
				frame:SetAlpha(1)
				frame:Show()
				bar:Update(0)
				bar.skined = true
			end
			bar:ApplyStyle()
		end
	end
end

local DBMSkin = CreateFrame("Frame")
	DBMSkin:RegisterEvent("PLAYER_LOGIN")
	DBMSkin:RegisterEvent("ADDON_LOADED")
	DBMSkin:SetScript("OnEvent", function()
		if IsAddOnLoaded("DBM-Core") then
			hooksecurefunc(DBT, "CreateBar", SkinBars)
			
			DBT_AllPersistentOptions["Default"]["DBM"].FontFlag = "OUTLINE"
			DBT_AllPersistentOptions["Default"]["DBM"].BarYOffset = 5
			DBT_AllPersistentOptions["Default"]["DBM"].Spark = false
		end
	end)