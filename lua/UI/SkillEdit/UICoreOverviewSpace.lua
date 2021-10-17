require("UI.UIBaseCtrl")

UICoreOverviewSpace = class("UICoreOverviewSpace", UIBaseCtrl);
UICoreOverviewSpace.__index = UICoreOverviewSpace

UICoreOverviewSpace.mImage_UI_CoreOverviewSpaceEmpty = nil;
UICoreOverviewSpace.mImage_UI_CoreOverviewSpaceLocked = nil;
UICoreOverviewSpace.mImage_UI_CoreOverviewSpaceActive = nil;
UICoreOverviewSpace.mImage_UI_CoreOverviewSpaceEquiped = nil;

function UICoreOverviewSpace:InitCtrl(root)

	self:SetRoot(root);

	self.mImage_UI_CoreOverviewSpaceEmpty = self:GetImage("UI_CoreOverviewSpaceEmpty");
	self.mImage_UI_CoreOverviewSpaceLocked = self:GetImage("UI_CoreOverviewSpaceLocked");
	self.mImage_UI_CoreOverviewSpaceActive = self:GetImage("UI_CoreOverviewSpaceActive");
	self.mImage_UI_CoreOverviewSpaceEquiped = self:GetImage("UI_CoreOverviewSpaceEquiped");
	
	setactive(self.mImage_UI_CoreOverviewSpaceEmpty.gameObject, false);
	setactive(self.mImage_UI_CoreOverviewSpaceLocked.gameObject, false);
	setactive(self.mImage_UI_CoreOverviewSpaceActive.gameObject, false);
	setactive(self.mImage_UI_CoreOverviewSpaceEquiped.gameObject, false);
end

function UICoreOverviewSpace:InitGrid(spaceStatus)
	if spaceStatus == 0 then
		setactive(self.mImage_UI_CoreOverviewSpaceEmpty.gameObject, true);
	end
	if spaceStatus == 1 then
		setactive(self.mImage_UI_CoreOverviewSpaceActive.gameObject, true);
	end
	if spaceStatus == 2 then
		setactive(self.mImage_UI_CoreOverviewSpaceLocked.gameObject, true);
	end	
	if spaceStatus == 3 then
		setactive(self.mImage_UI_CoreOverviewSpaceEquiped.gameObject, true);
	end	
end