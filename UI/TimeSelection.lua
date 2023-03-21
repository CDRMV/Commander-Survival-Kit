local LazyVar = import('/lua/lazyvar.lua')
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
local Group = import('/lua/maui/group.lua').Group
local Text = import('/lua/maui/text.lua').Text
local MultiLineText = import('/lua/maui/multilinetext.lua').MultiLineText
local Button = import('/lua/maui/button.lua').Button
local Edit = import('/lua/maui/edit.lua').Edit
local Checkbox = import('/lua/maui/Checkbox.lua').Checkbox
local Scrollbar = import('/lua/maui/scrollbar.lua').Scrollbar
local Bitmap = import('/lua/maui/bitmap.lua').Bitmap
local Cursor = import('/lua/maui/cursor.lua').Cursor
local Prefs = import('/lua/user/prefs.lua')
local Border = import('/lua/maui/border.lua').Border
local ItemList = import('/lua/maui/itemlist.lua').ItemList
local Layouts = import('/lua/skins/layouts.lua')
local UIUtil = import('/lua/ui/uiutil.lua')
local SkinnableFile = import('/lua/ui/uiutil.lua').SkinnableFile
local CreateText = import('/lua/ui/uiutil.lua').CreateText
local CreateDialogBrackets = import('/lua/ui/uiutil.lua').CreateDialogBrackets
local CreateWorldCover = import('/lua/ui/uiutil.lua').CreateWorldCover
local CreateButtonStd = import('/lua/ui/uiutil.lua').CreateButtonStd


buttonFont = import('/lua/lazyvar.lua').Create()			-- default font used for button faces
factionFont = import('/lua/lazyvar.lua').Create()	   -- default font used for dialog button faces
dialogButtonFont = import('/lua/lazyvar.lua').Create()		-- default font used for dialog button faces
bodyFont = import('/lua/lazyvar.lua').Create()				-- font used for all other text
fixedFont = import('/lua/lazyvar.lua').Create()				-- font used for fixed width characters
titleFont = import('/lua/lazyvar.lua').Create()				-- font used for titles and labels
fontColor = import('/lua/lazyvar.lua').Create()				-- common font color
fontOverColor = import('/lua/lazyvar.lua').Create()				-- common font color
fontDownColor = import('/lua/lazyvar.lua').Create()				-- common font color
tooltipTitleColor = import('/lua/lazyvar.lua').Create()				-- common font color
tooltipBorderColor = import('/lua/lazyvar.lua').Create()			 -- common font color
bodyColor = import('/lua/lazyvar.lua').Create()				-- common color for dialog body text
dialogCaptionColor = import('/lua/lazyvar.lua').Create()	-- common color for dialog titles
dialogColumnColor = import('/lua/lazyvar.lua').Create()		-- common color for column headers in a dialog
dialogButtonColor = import('/lua/lazyvar.lua').Create()		-- common color for buttons in a dialog
highlightColor = import('/lua/lazyvar.lua').Create()		-- text highlight color
disabledColor = import('/lua/lazyvar.lua').Create()			-- text disabled color
panelColor = import('/lua/lazyvar.lua').Create()			-- default color when drawing a panel
transparentPanelColor = import('/lua/lazyvar.lua').Create() -- default color when drawing a transparent panel
consoleBGColor = import('/lua/lazyvar.lua').Create()		-- console background color
consoleFGColor = import('/lua/lazyvar.lua').Create()		-- console foreground color (text)
consoleTextBGColor = import('/lua/lazyvar.lua').Create()	-- console text background color
menuFontSize = import('/lua/lazyvar.lua').Create()			-- font size used on main in game escape menu 

local selectedtime = -1

function QuickDialog(
parent, 
dialogText, 
button1Text, 
button1Callback, 
button2Text, 
button2Callback, 
button3Text, 
button3Callback, 
button4Text, 
button4Callback, 
button5Text, 
button5Callback, 
button6Text, 
button6Callback, 
destroyOnCallback, 
modalInfo)

	
	-- if there is a callback and destroy not specified, assume destroy
	if (destroyOnCallback == nil) and (button1Callback or button2Callback or button3Callback) then
		destroyOnCallback = true
	end

	local dialog = Group(parent, "quickDialogGroup")

	LayoutHelpers.AtCenterIn(dialog, parent)
	dialog.Depth:Set(GetFrame(parent:GetRootFrame():GetTargetHead()):GetTopmostDepth() + 1)
	local background = Bitmap(dialog, SkinnableFile('/mods/Commander Survival Kit/textures/panel_bmp_m2.dds'))
	background.Width:Set(700)
	dialog._background = background
	dialog.Width:Set(background.Width)
	dialog.Height:Set(background.Height)
	LayoutHelpers.FillParent(background, dialog)
	
	local textLine = {}
	textLine[1] = CreateText(dialog, "", 18, titleFont)
	textLine[1].Top:Set(background.Top)
	LayoutHelpers.AtHorizontalCenterIn(textLine[1], dialog)
	
	local textBoxWidth = (dialog.Width() - 80) 
	local tempTable = import('/lua/maui/text.lua').WrapText(LOC(dialogText), textBoxWidth,
	function(text)
		return textLine[1]:GetStringAdvance(text)
	end)

	local tempLines = table.getn(tempTable)
	
	local prevControl = false
	for i, v in tempTable do
		if i == 1 then
			textLine[1]:SetText(v)
			prevControl = textLine[1]
		else
			textLine[i] = CreateText(dialog, v, 18, titleFont)
			LayoutHelpers.Below(textLine[i], prevControl)
			LayoutHelpers.AtHorizontalCenterIn(textLine[i], dialog)
			prevControl = textLine[i]
		end
	end
	
	background:SetTiled(true)
	background.Bottom:Set(textLine[tempLines].Bottom)
	
	local backgroundTop = Bitmap(dialog, SkinnableFile('/dialogs/dialog/panel_bmp_T.dds'))
			backgroundTop.Width:Set(700)
	backgroundTop.Bottom:Set(background.Top)
	backgroundTop.Left:Set(background.Left)
	local backgroundBottom = Bitmap(dialog, SkinnableFile('/dialogs/dialog/panel_bmp_b.dds'))
	backgroundBottom.Width:Set(700)
					backgroundBottom.Height:Set(140)
	backgroundBottom.Top:Set(background.Bottom)
	backgroundBottom.Left:Set(background.Left)
	

	
	background.brackets = CreateDialogBrackets(background, 35, 55, 35, 170, false)
	
	if not modalInfo or modalInfo.worldCover then
		CreateWorldCover(dialog)
	end
	
	function MakeButton(text, value)
	   button = CreateButtonStd( background
										, '/scx_menu/small-btn/small'
										, text
										, 14
										, 2)
		if value == 5 then
			button.OnClick = function(self)
				selectedtime = 300
				Setselectedtime(selectedtime)
				if destroyOnCallback then
					dialog:Destroy()
				end
			end
		elseif value == 15 then
			button.OnClick = function(self)
				selectedtime = 900
				if destroyOnCallback then
					dialog:Destroy()
				end
			end
		elseif value == 25 then
			button.OnClick = function(self)
				selectedtime = 1500
				if destroyOnCallback then
					dialog:Destroy()
				end
			end
		elseif value == 35 then
			button.OnClick = function(self)
				selectedtime = 2100
				if destroyOnCallback then
					dialog:Destroy()
				end
			end
		elseif value == 45 then
			button.OnClick = function(self)
				selectedtime = 2700
				if destroyOnCallback then
					dialog:Destroy()
				end
			end
		elseif value == 60 then
			button.OnClick = function(self)
				selectedtime = 3600
				if destroyOnCallback then
					dialog:Destroy()
				end
			end
		else
			button.OnClick = function(self)
				dialog:Destroy()
			end
		end
		return button
	end

	dialog._button1 = false
	dialog._button2 = false
	dialog._button3 = false
		dialog._button4 = false
			dialog._button5 = false
		dialog._button6 = false


	if button1Text then
		dialog._button1 = MakeButton(button1Text, button1Callback)
		LayoutHelpers.Below(dialog._button1, prevControl)
			LayoutHelpers.AtHorizontalCenterIn(dialog._button1, background)
			
	end
	if button2Text then
		dialog._button2 = MakeButton(button2Text, button2Callback)
		LayoutHelpers.Below(dialog._button2, prevControl)
			LayoutHelpers.AtHorizontalCenterIn(dialog._button2, background)
			prevControl = dialog._button2
	end
	if button3Text then
		dialog._button3 = MakeButton(button3Text, button3Callback)
		LayoutHelpers.Below(dialog._button3, prevControl)
			LayoutHelpers.AtHorizontalCenterIn(dialog._button3, background)
			prevControl = dialog._button3
	end
	
	if button4Text then
		dialog._button4 = MakeButton(button4Text, button4Callback)
		LayoutHelpers.Below(dialog._button4, prevControl)
			LayoutHelpers.AtHorizontalCenterIn(dialog._button4, background)
	end
	
		if button5Text then
		dialog._button5 = MakeButton(button5Text, button5Callback)
		LayoutHelpers.Below(dialog._button5, prevControl)
			LayoutHelpers.AtHorizontalCenterIn(dialog._button5, background)
	end
	
		if button6Text then
		dialog._button6 = MakeButton(button6Text, button6Callback)
		LayoutHelpers.Below(dialog._button6, prevControl)
			LayoutHelpers.AtHorizontalCenterIn(dialog._button6, background)
	end
	
	if dialog._button3 then
		-- center each button to one third of the dialog
		LayoutHelpers.AtHorizontalCenterIn(dialog._button2, dialog)
		LayoutHelpers.LeftOf(dialog._button1, dialog._button2, -8)
		LayoutHelpers.ResetLeft(dialog._button1)
		LayoutHelpers.RightOf(dialog._button3, dialog._button2, -8)
	elseif dialog._button2 then
		-- center each button to half the dialog
		dialog._button1.Left:Set(function()
			return dialog.Left() + (((dialog.Width() / 2) - dialog._button1.Width()) / 2) + 8
		end)
		dialog._button2.Left:Set(function()
			local halfWidth = dialog.Width() / 2
			return dialog.Left() + halfWidth + ((halfWidth - dialog._button2.Width()) / 2) - 8
		end)
	elseif dialog._button1 then
		LayoutHelpers.AtHorizontalCenterIn(dialog._button1, dialog)
	else

	end
	
	if dialog._button6 then
		-- center each button to one third of the dialog
		LayoutHelpers.AtHorizontalCenterIn(dialog._button5, dialog)
		LayoutHelpers.LeftOf(dialog._button4, dialog._button5, -8)
		LayoutHelpers.ResetLeft(dialog._button4)
		LayoutHelpers.RightOf(dialog._button6, dialog._button5, -8)
	elseif dialog._button5 then
		-- center each button to half the dialog
		dialog._button4.Left:Set(function()
			return dialog.Left() + (((dialog.Width() / 2) - dialog._button4.Width()) / 2) + 8
		end)
		dialog._button5.Left:Set(function()
			local halfWidth = dialog.Width() / 2
			return dialog.Left() + halfWidth + ((halfWidth - dialog._button5.Width()) / 2) - 8
		end)

	elseif dialog._button4 then
		LayoutHelpers.AtHorizontalCenterIn(dialog._button4, dialog)

	else
	end

	if modalInfo and not modalInfo.OnlyWorldCover then
		local function OnEnterFunc()
			if modalInfo.enterButton then
				if modalInfo.enterButton == 1 then
					if dialog._button1 then
						dialog._button1.OnClick(dialog._button1)
					end
				elseif modalInfo.enterButton == 2 then
					if dialog._button2 then
						dialog._button2.OnClick(dialog._button2)
					end
				elseif modalInfo.enterButton == 3 then
					if dialog._button3 then
						dialog._button3.OnClick(dialog._button3)
					end	
				elseif modalInfo.enterButton == 4 then
					if dialog._button4 then
						dialog._button4.OnClick(dialog._button4)
					end
				elseif modalInfo.enterButton == 5 then
					if dialog._button5 then
						dialog._button5.OnClick(dialog._button5)
					end
				elseif modalInfo.enterButton == 6 then
					if dialog._button6 then
						dialog._button6.OnClick(dialog._button6)
					end
				end
			end
		end
		
		local function OnEscFunc()
			if modalInfo.escapeButton then
				if modalInfo.escapeButton == 1 then
					if dialog._button1 then
						dialog._button1.OnClick(dialog._button1)
					end
				elseif modalInfo.escapeButton == 2 then
					if dialog._button2 then
						dialog._button2.OnClick(dialog._button2)
					end
				elseif modalInfo.escapeButton == 3 then
					if dialog._button3 then
						dialog._button3.OnClick(dialog._button3)
					end
				elseif modalInfo.escapeButton == 4 then
					if dialog._button4 then
						dialog._button4.OnClick(dialog._button4)
					end
				elseif modalInfo.escapeButton == 5 then
					if dialog._button5 then
						dialog._button5.OnClick(dialog._button5)
					end
				elseif modalInfo.escapeButton == 6 then
					if dialog._button6 then
						dialog._button6.OnClick(dialog._button6)
					end
				end
			end
		end
		

		
		MakeInputModal(dialog, OnEnterFunc, OnEscFunc)
	end

	return dialog
end

function Setselectedtime(value)
	selectedtime = value
	LOG(selectedtime)
	return 
end

function returnSelectedTime()
	return selectedtime
end


UI = QuickDialog(GetFrame(0), "Select Point Generation start time:", "5 Minutes", 5, "15 Minutes", 15, "25 Minutes", 25, "35 Minutes", 35, "45 Minutes", 45, "60 Minutes", 60)

UI:Hide()

