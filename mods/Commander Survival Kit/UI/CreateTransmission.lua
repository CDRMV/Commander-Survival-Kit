
local path = '/mods/Commander Survival Kit/UI/'
local CTransmissionUI = import(path .. 'ComingTransmission.lua').UI
local ETransmissionUI = import(path .. 'EndingTransmission.lua').UI
local TransmissionUI = import(path .. 'Transmission.lua').UI
local CTransmissionMovieUI = import(path .. 'ComingTransmission.lua').MovieUI
local ETransmissionMovieUI = import(path .. 'EndingTransmission.lua').MovieUI
local TransmissionMovieUI = import(path .. 'Transmission.lua').MovieUI
local CTransmissionTextUI = import(path .. 'ComingTransmission.lua').TextUI
local ETransmissionTextUI = import(path .. 'EndingTransmission.lua').TextUI
local TransmissionTextUI = import(path .. 'Transmission.lua').TextUI

local TransmissionText = import(path .. 'Transmission.lua').Text
local TransmissionText2 = import(path .. 'Transmission.lua').Text2
local TransmissionText3 = import(path .. 'Transmission.lua').Text3
local TransmissionText4 = import(path .. 'Transmission.lua').Text4
local TransmissionText5 = import(path .. 'Transmission.lua').Text5

TransmissionUI:Hide()
CTransmissionUI:Hide()
ETransmissionUI:Hide()

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
				CTransmissionUI:Show()
				CTransmissionUI._closeBtn:Hide()
				CTransmissionMovieUI._closeBtn:Hide()
				CTransmissionTextUI._closeBtn:Hide()
				WaitSeconds(2)
				CTransmissionUI:Hide()
				TransmissionUI:Show()
				TransmissionUI._closeBtn:Hide()
				TransmissionMovieUI._closeBtn:Hide()
				TransmissionTextUI._closeBtn:Hide()
				WaitSeconds(10)
				TransmissionUI:Hide()
				ETransmissionUI:Show()
				ETransmissionUI._closeBtn:Hide()
				ETransmissionMovieUI._closeBtn:Hide()
				ETransmissionTextUI._closeBtn:Hide()
				WaitSeconds(2)
				ETransmissionUI:Hide()
	end	
)
end