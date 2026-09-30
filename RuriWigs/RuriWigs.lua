--==============================================--
---------------    [[ Notes ]]     ---------------
--==============================================--

-- Custom Bar Styles
-- https://github.com/BigWigsMods/BigWigs/wiki/Custom-Bar-Styles

--===============================================--
---------------    [[ config ]]     ---------------
--===============================================--

if not BigWigsAPI then return end

local glowTex = "Interface\\AddOns\\RuriWigs\\Media\\glow"
local bgTex = "Interface\\Buttons\\WHITE8X8"
local indicatorOffset = 2
local indicatorOffsetWithIcon = 36

local backdropBorder = {
	bgFile = bgTex,
	edgeFile = glowTex,
	tile = false, tileSize = 0, edgeSize = 3,
	insets = {left = 3, right = 3, top = 3, bottom = 3}
}

--==================================================--
---------------    [[ Functions ]]     ---------------
--==================================================--

local function removeStyle(bar)
	local cbb = bar.candyBarBar

	bar.candyBarBackdrop:Hide()
	bar.candyBarIconFrameBackdrop:Hide()
	local indicatorAnchor = bar:Get("ruriwigs:indicatoranchor")
	if indicatorAnchor then
		local indicatorFrame = bar:Get("bigwigs:indicatorFrame")
		if indicatorFrame == indicatorAnchor[1] and indicatorFrame.bar == bar then
			indicatorFrame:ClearAllPoints()
			indicatorFrame:SetPoint(indicatorAnchor[2], indicatorAnchor[3], indicatorAnchor[4], indicatorAnchor[5], indicatorAnchor[6])
		end
		bar:Set("ruriwigs:indicatoranchor", nil)
	end
	local height = bar:Get("ruriwigs:restoreheight")
	if height then
		bar:SetHeight(height)
		bar:Set("ruriwigs:restoreheight", nil)
	end

	local shadowOffsets = bar:Get("ruriwigs:shadowoffsets")
	if shadowOffsets then
		bar.candyBarLabel:SetShadowOffset(shadowOffsets[1], shadowOffsets[2])
		bar.candyBarDuration:SetShadowOffset(shadowOffsets[3], shadowOffsets[4])
		bar:Set("ruriwigs:shadowoffsets", nil)
	end

	local timer = bar.candyBarDuration
	timer:ClearAllPoints()
	timer:SetPoint("TOPLEFT", cbb, "TOPLEFT", 2, 0)
	timer:SetPoint("BOTTOMRIGHT", cbb, "BOTTOMRIGHT", -2, 0)

	local label = bar.candyBarLabel
	label:ClearAllPoints()
	label:SetPoint("TOPLEFT", cbb, "TOPLEFT", 2, 0)
	label:SetPoint("BOTTOMRIGHT", cbb, "BOTTOMRIGHT", -2, 0)
end

local function styleBar(bar)
	local cbb = bar.candyBarBar

	local height = bar:GetHeight()
	bar:Set("ruriwigs:restoreheight", height)
	bar:SetHeight(height/2)

	local bd = bar.candyBarBackdrop
	if bd.SetToDefaults then
		bd:SetToDefaults()
		bd:SetFrameLevel(0)
	end
	bd:SetBackdrop(backdropBorder)
	bd:SetBackdropColor(0, 0, 0, .4)
	bd:SetBackdropBorderColor(0, 0, 0, 1)
	bd:ClearAllPoints()
	bd:SetPoint("TOPLEFT", bar, "TOPLEFT", -3, 3)
	bd:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 3, -3)
	bd:Show()

	local icon = bar.candyBarIconFrame
	local iconBd = bar.candyBarIconFrameBackdrop
	local reApplyIcon
	-- Release a secret anchor before moving the icon outside the status bar.
	if icon.IsAnchoringSecret and icon:IsAnchoringSecret() then
		reApplyIcon = bar:GetIcon()
		icon:SetToDefaults()
		iconBd:SetToDefaults()
		iconBd:SetFrameLevel(0)
	end

	-- LibCandyBar resets these anchors when the bar height changes.
	cbb:ClearAllPoints()
	cbb:SetAllPoints(bar)
	icon:ClearAllPoints()
	iconBd:ClearAllPoints()
	if bar:GetIconPosition() == "RIGHT" then
		icon:SetPoint("BOTTOMLEFT", bar, "BOTTOMRIGHT", 5, 0)
	else
		icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -5, 0)
	end
	icon:SetSize(height+2, height+2)

	iconBd:SetBackdrop(backdropBorder)
	iconBd:SetBackdropColor(.15, .15, .15, .4)
	iconBd:SetBackdropBorderColor(0, 0, 0, 1)
	iconBd:SetPoint("TOPLEFT", icon, "TOPLEFT", -3, 3)
	iconBd:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 3, -3)
	iconBd:SetShown(bar:IsIconVisible())

	if reApplyIcon then
		icon:SetTexture(reApplyIcon)
		icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	end

	-- BigWigs creates the indicator before ApplyStyle; restore its anchor in BarStopped.
	local indicatorFrame = bar:Get("bigwigs:indicatorFrame")
	if indicatorFrame and indicatorFrame.bar == bar then
		local point, relativeTo, relativePoint, x, y = indicatorFrame:GetPoint(1)
		local onLeft = point == "BOTTOMRIGHT" and relativePoint == "BOTTOMLEFT"
		local onRight = point == "BOTTOMLEFT" and relativePoint == "BOTTOMRIGHT"
		if relativeTo == bar and (onLeft or onRight) then
			if not bar:Get("ruriwigs:indicatoranchor") then
				bar:Set("ruriwigs:indicatoranchor", {indicatorFrame, point, relativeTo, relativePoint, x, y})
			end

			-- Leave room for the icon and its shadow only when both are on the same side.
			local iconOnRight = bar:GetIconPosition() == "RIGHT"
			local sameSide = bar:IsIconVisible() and ((onLeft and not iconOnRight) or (onRight and iconOnRight))
			local offset = sameSide and indicatorOffsetWithIcon or indicatorOffset
			indicatorFrame:ClearAllPoints()
			indicatorFrame:SetPoint(point, bar, relativePoint, onLeft and -offset or offset, y)
		end
	end

	local label = bar.candyBarLabel
	local timer = bar.candyBarDuration
	local labelShadowX, labelShadowY = label:GetShadowOffset()
	local timerShadowX, timerShadowY = timer:GetShadowOffset()
	bar:Set("ruriwigs:shadowoffsets", {labelShadowX, labelShadowY, timerShadowX, timerShadowY})
	label:SetShadowOffset(0, 0)
	label:ClearAllPoints()
	label:SetPoint("BOTTOMLEFT", cbb, "TOPLEFT", 2, -height/4+2)

	timer:SetShadowOffset(0, 0)
	timer:ClearAllPoints()
	timer:SetPoint("BOTTOMRIGHT", cbb, "TOPRIGHT", -2, -height/4+2)
	
	bar:SetTexture(bgTex)
end

BigWigsAPI:RegisterBarStyle("Ruri", {
	apiVersion = 1,
	version = 13,
	barHeight = 24,
	GetSpacing = function(bar) return bar:GetHeight()+10 end,
	spellIndicatorsOffset = indicatorOffset,
	fontSizeNormal = 14,
	fontSizeEmphasized = 14,
	fontOutline = "OUTLINE",
	ApplyStyle = styleBar,
	BarStopped = removeStyle,
	GetStyleName = function() return "Ruri" end,
})
