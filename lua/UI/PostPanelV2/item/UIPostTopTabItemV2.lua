require("UI.UIBaseCtrl")

---@class UIPostTopTabItemV2 : UIBaseCtrl
UIPostTopTabItemV2 = class("UIPostTopTabItemV2", UIBaseCtrl);
UIPostTopTabItemV2.__index = UIPostTopTabItemV2
--@@ GF Auto Gen Block Begin
UIPostTopTabItemV2.mBtn = nil;
UIPostTopTabItemV2.mText_Name = nil;
UIPostTopTabItemV2.mTrans_RedPoint = nil;

function UIPostTopTabItemV2:__InitCtrl()

	self.mText_Name = self:GetText("Text_Name");
	self.mTrans_RedPoint = self:GetRectTransform("Trans_RedPoint");
end

--@@ GF Auto Gen Block End

function UIPostTopTabItemV2:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();
	
	self.mBtn = self:GetSelfButton()
	self.mAnimator = getcomponent(root.gameObject, typeof(CS.UnityEngine.Animator))
end

function UIPostTopTabItemV2:SetData(type)
	self.mText_Name.text = TableData.GetHintById(805 + type)
end