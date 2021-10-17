require("UI.UIBaseCtrl")

UIPropertyFoldItem = class("UIPropertyFoldItem", UIBaseCtrl);
UIPropertyFoldItem.__index = UIPropertyFoldItem
--@@ GF Auto Gen Block Begin
UIPropertyFoldItem.mImage_icon = nil;
UIPropertyFoldItem.mText_PropertyText = nil;
UIPropertyFoldItem.mText_overviewAttackNum = nil;

function UIPropertyFoldItem:__InitCtrl()

	self.mImage_icon = self:GetImage("Image_icon");
	self.mText_PropertyText = self:GetText("Text_PropertyText");
	self.mText_overviewAttackNum = self:GetText("Text_overviewAttackNum");
end

--@@ GF Auto Gen Block End

function UIPropertyFoldItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIPropertyFoldItem:SetData(name,sys_name,value,isPercent)
	local txt = value;

	--移动距离变为可养成属性，增加新的算法：
	--移动距离(单位=格)=移速(单位局内属性)/100，保留2位小数
	-- if(sys_name == "max_ap") then
	-- 	txt = txt / CS.GFConstBase.FTI2Rate;
	-- end

	if(isPercent == true) then
		txt = (txt/10).."%";
	end

	self.mText_PropertyText.text = name.str;
	self.mText_overviewAttackNum.text = txt;
end