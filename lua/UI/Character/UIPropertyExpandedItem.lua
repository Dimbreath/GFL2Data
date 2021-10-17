require("UI.UIBaseCtrl")

UIPropertyExpandedItem = class("UIPropertyExpandedItem", UIBaseCtrl);
UIPropertyExpandedItem.__index = UIPropertyExpandedItem
--@@ GF Auto Gen Block Begin

UIPropertyExpandedItem.mImage_icon = nil;
UIPropertyExpandedItem.mText_PropertyText = nil;
UIPropertyExpandedItem.mText_overviewAttackNum1 = nil;
UIPropertyExpandedItem.mText_overviewAttackNum2 = nil;

function UIPropertyExpandedItem:__InitCtrl()
	self.mImage_icon = self:GetImage("icon");
	self.mText_PropertyText = self:GetText("Text");
	self.mText_overviewAttackNum1 = self:GetText("UI_overviewAttackNum");
	self.mText_overviewAttackNum2 = self:GetText("UI_overviewAttackNum (1)");
end

--@@ GF Auto Gen Block End

function UIPropertyExpandedItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIPropertyExpandedItem:SetData(name,sys_name,value1,value2,isPercent)
	self.mText_PropertyText.text = name.str;

	local txt1 = value1;
	local txt2 = value2;

	--移动距离变为可养成属性，增加新的算法：
	--移动距离(单位=格)=移速(单位局内属性)/100，保留2位小数
	-- if(sys_name == "max_ap") then
	-- 	txt1 = txt1 / CS.GFConstBase.FTI2Rate;
	-- 	txt2 = txt2 / CS.GFConstBase.FTI2Rate;
	-- end

	if(isPercent == true) then
		txt1 = (txt1/10).."%";
		txt2 = (txt2/10).."%";
	end

	self.mText_overviewAttackNum1.text = txt1;
	self.mText_overviewAttackNum2.text = txt2;

	
end