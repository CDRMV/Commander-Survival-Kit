
local path = '/mods/Commander Survival Kit/UI/'
local TransmissionUI = import(path .. 'Transmission.lua').UI
local TransmissionMovieUI = import(path .. 'Transmission.lua').MovieUI
local TransmissionTextUI = import(path .. 'Transmission.lua').TextUI

local TransmissionText = import(path .. 'Transmission.lua').Text
local TransmissionText2 = import(path .. 'Transmission.lua').Text2
local TransmissionText3 = import(path .. 'Transmission.lua').Text3
local TransmissionText4 = import(path .. 'Transmission.lua').Text4
local TransmissionText5 = import(path .. 'Transmission.lua').Text5

TransmissionUI:Hide()

function CreateTransmission(
text, text2, text3, text4, text5)
ForkThread(
	function()
				TransmissionText:SetText(text)
				TransmissionText2:SetText(text2)
				TransmissionText3:SetText(text3)
				TransmissionText4:SetText(text4)
				TransmissionText5:SetText(text5)
				WaitSeconds(10)
				TransmissionUI:Show()
				TransmissionUI._closeBtn:Hide()
				TransmissionMovieUI._closeBtn:Hide()
				TransmissionTextUI._closeBtn:Hide()
				WaitSeconds(10)
				TransmissionUI:Hide()
	end	
)
end