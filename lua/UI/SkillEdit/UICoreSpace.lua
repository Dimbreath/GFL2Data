require("UI.UIBaseCtrl")

UICoreSpace = class("UICoreSpace", UIBaseCtrl);
UICoreSpace.__index = UICoreSpace

UICoreSpace.mImage_UI_CoreSpaceLocked = nil;
UICoreSpace.mImage_UI_CoreSpaceActive = nil;

function UICoreSpace:InitCtrl(root)

	self:SetRoot(root);

	self.mImage_UI_CoreSpaceLocked = self:GetImage("UI_CoreSpaceLocked");
	self.mImage_UI_CoreSpaceActive = self:GetImage("UI_CoreSpaceActive");
end

function UICoreSpace:InitGrid(isActive)
	if isActive == 0 then
		setactive(self.mImage_UI_CoreSpaceLocked.gameObject, true);
		setactive(self.mImage_UI_CoreSpaceActive.gameObject, false);
	else
		setactive(self.mImage_UI_CoreSpaceLocked.gameObject, false);
		setactive(self.mImage_UI_CoreSpaceActive.gameObject, true);
	end	
end
