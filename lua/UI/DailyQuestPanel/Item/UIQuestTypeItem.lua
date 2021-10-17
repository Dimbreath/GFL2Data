require("UI.UIBaseCtrl")

UIQuestTypeItem = class("UIQuestTypeItem", UIBaseCtrl);
UIQuestTypeItem.__index = UIQuestTypeItem
--@@ GF Auto Gen Block Begin
UIQuestTypeItem.mBtn_Sel = nil;
--UIQuestTypeItem.mImage_Off_TabIcon = nil;
--UIQuestTypeItem.mImage_On_TabIcon = nil;
--UIQuestTypeItem.mText_Off_TabTitle = nil;
UIQuestTypeItem.mText_On_TabTitle = nil;
--UIQuestTypeItem.mTrans_Off = nil;
--UIQuestTypeItem.mTrans_On = nil;
UIQuestTypeItem.mTrans_RedPoint = nil;
function UIQuestTypeItem:__InitCtrl()

	self.mBtn_Sel = self:GetSelfButton();
	--self.mImage_Off_TabIcon = self:GetImage("UI_Trans_Off/Image_TabIcon");
	--self.mImage_On_TabIcon = self:GetImage("UI_Trans_On/Image_TabIcon");
	--self.mText_Off_TabTitle = self:GetText("UI_Trans_Off/Text_TabTitle");
	self.mText_On_TabTitle = self:GetText("Text_Name");
	--self.mTrans_Off = self:GetRectTransform("UI_Trans_Off");
	--self.mTrans_On = self:GetRectTransform("UI_Trans_On");
	self.mTrans_RedPoint = self:GetRectTransform("Trans_RedPoint");

	self.mTrans_Lock = self:GetRectTransform("Trans_GrpLocked")
end

--@@ GF Auto Gen Block End

function UIQuestTypeItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIQuestTypeItem:SetData(data)
	self.data = data
	if data then
		self.mText_On_TabTitle.text = data.type_name.str
	end

	if(not AccountNetCmdHandler:CheckSystemIsUnLock(data.unlock)) then
		setactive(self.mTrans_Lock,true)
		setactive(self.mTrans_RedPoint.gameObject, false)
	else
		setactive(self.mTrans_Lock,false)
	end
end

function UIQuestTypeItem:SetItemState(isChoose)
	self.isChoose = isChoose
	self.mBtn_Sel.interactable = not isChoose
	--setactive(self.mTrans_Off.gameObject, not self.isChoose)
	--setactive(self.mTrans_On.gameObject, self.isChoose)
end

function UIQuestTypeItem:UpdateRedPoint()
	setactive(self.mTrans_RedPoint.gameObject, false)
	
	if(not AccountNetCmdHandler:CheckSystemIsUnLock(self.data.unlock)) then
		setactive(self.mTrans_RedPoint.gameObject, false)
		return
	end

	local hasNew = NetCmdQuestData:CheckIshaveGetReward(self.data.type)
	if hasNew == true then
		setactive(self.mTrans_RedPoint.gameObject, true)
	end
	--setactive(self.mTrans_CommonTabButtonItem_RedPoint, hasNew)
end
