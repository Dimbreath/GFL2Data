require("UI.UIBaseCtrl")

GachaEventItem = class("GachaEventItem", UIBaseCtrl);
GachaEventItem.__index = GachaEventItem
--@@ GF Auto Gen Block Begin
GachaEventItem.mBtn_GachaEventBtn = nil;
GachaEventItem.mText_EventNameSel = nil;
GachaEventItem.mText_Text = nil;
GachaEventItem.mText_EventNameUnsel = nil;
GachaEventItem.mTrans_Sel = nil;
GachaEventItem.mTrans_UnSel = nil;
GachaEventItem.mTrans_NewTab = nil;
GachaEventItem.mTrans_CountDown = nil;


GachaEventItem.mEventData = nil;

function GachaEventItem:__InitCtrl()

	self.mBtn_GachaEventBtn = self:GetButton("Btn_GachaEventBtn");
	self.mText_EventNameSel = self:GetText("Btn_GachaEventBtn/Trans_Sel/UpPanel/Text_EventNameSel");
	self.mText_Text = self:GetText("Btn_GachaEventBtn/Trans_Sel/UpPanel/CountDown/BG/Text_Text");
	self.mText_EventNameUnsel = self:GetText("Btn_GachaEventBtn/Trans_UnSel/UpPanel/Text_EventNameUnsel");
	self.mTrans_Sel = self:GetRectTransform("Btn_GachaEventBtn/Trans_Sel");
	self.mTrans_UnSel = self:GetRectTransform("Btn_GachaEventBtn/Trans_UnSel");
	self.mTrans_NewTab = self:GetRectTransform("Btn_GachaEventBtn/Trans_NewTab");
	self.mTrans_CountDown = self:GetRectTransform("Btn_GachaEventBtn/Trans_Sel/UpPanel/CountDown");
end

--@@ GF Auto Gen Block End

function GachaEventItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function GachaEventItem:InitData(data)
	self.mEventData = data;
	
	self.mText_EventNameSel.text = data.Name;
	self.mText_EventNameUnsel.text = data.Name;
	
	if(data.IsNormalEvent == false) then
		self.mText_Text.text = data.RemainTime;
	else
		setactive(self.mTrans_CountDown.gameObject, false);
	end
	
	self:SetSelect(false);
end

function GachaEventItem:SetSelect(isSelect)
	setactive(self.mTrans_Sel.gameObject,isSelect);
	setactive(self.mTrans_UnSel.gameObject,not isSelect);
end