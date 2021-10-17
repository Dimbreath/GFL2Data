require("UI.UIBaseCtrl")

UICheckInItem = class("UICheckInItem", UIBaseCtrl)
UICheckInItem.__index = UICheckInItem
--@@ GF Auto Gen Block Begin
--UICheckInItem.mImage_BGImage = nil
UICheckInItem.mImage_Picture = nil
UICheckInItem.mText_Count = nil
UICheckInItem.mText_CheckInCount = nil
UICheckInItem.mText_CheckInDateText = nil
UICheckInItem.mTrans_CheckInItemInfor = nil
UICheckInItem.mTrans_CheckInMask = nil

function UICheckInItem:__InitCtrl()

	--self.mImage_BGImage = self:GetImage("Trans_CheckInItemInfor/Image_BGImage")
	self.mImage_Picture = self:GetImage("GrpItemIcon/Img_Icon")
	self.mImage_Rank = self:GetImage("GrpQualityLine/Img_LineCor")
	self.mText_Count = self:GetText("GrpItemNum/Text_Num")
	self.mText_CheckInCount = self:GetText("GrpDate/Text_Num")
	self.mText_CheckInDateText = self:GetText("GrpDate/TextTh")
	self.mTrans_CheckInItemInfor = self:GetRectTransform("Trans_CheckInItemInfor")
	self.mTrans_CheckInMask = self:GetRectTransform("GrpBlackMask")
	self.mTrans_AvailableMask = self:GetRectTransform("ImgCheck")
	self.mTrans_Received = self:GetRectTransform("Received")
end

--@@ GF Auto Gen Block End
--UICheckInItem.mTrans_maskImage = nil
UICheckInItem.mPath_item = "CheckIn/CheckInItemV2.prefab"
UICheckInItem.mData = nil

UICheckInItem.mButtonSelf = nil
UICheckInItem.mAnimator = nil;

function UICheckInItem:InitCtrl(parent)

	local obj=instantiate(UIUtils.GetGizmosPrefab(UICheckInItem.mPath_item,self))
    self:SetRoot(obj.transform)
	obj.transform:SetParent(parent, false)
    obj.transform.localScale=vectorone
    self:SetRoot(obj.transform)
	self:__InitCtrl()

	--self.mTrans_maskImage = self:GetRectTransform("Trans_CheckInItemInfor/Trans_CheckInMask/maskimage")
	self.mButtonSelf = self:GetSelfButton()
	self.mAnimator = obj:GetComponent("Animator");
end

function UICheckInItem:InitData(data)
	self.mData = data
	local stcData = TableData.GetItemData(data.ItemId)

	self.mText_CheckInCount.text = string.format("%02d", data.Day)
	self.mText_Count.text = data.ItemNum
	self.mImage_Picture.sprite = UIUtils.GetIconSprite("Icon/Item",stcData.icon)
	self.mImage_Rank.color = TableData.GetGlobalGun_Quality_Color2(stcData.rank)

	if(data.Day == 1) then
		self.mText_CheckInDateText.text = "st"
	elseif(data.Day == 2) then
		self.mText_CheckInDateText.text = "nd"
	elseif(data.Day == 3) then
		self.mText_CheckInDateText.text = "rd"
	else
		self.mText_CheckInDateText.text = "th"
	end
	
	TipsManager.Add(self:GetRoot().gameObject, stcData, nil, false)

	setactive(self.mTrans_AvailableMask.gameObject, false)
end

function UICheckInItem:SetMask()
	setactive(self.mTrans_CheckInMask,true)
	setactive(self.mTrans_Received.gameObject,true)
	setactive(self.mTrans_AvailableMask.gameObject, true)
end

function UICheckInItem:SetTransparent()
	-- local canvasGroup = self.mTrans_CheckInItemInfor:GetComponent("CanvasGroup")
	-- canvasGroup.alpha = 0.8

	setactive(self.mTrans_AvailableMask.gameObject, true)
end

function UICheckInItem:SetChecked(callback)
	setactive(self.mTrans_AvailableMask.gameObject, true)
	--setactive(self.mTrans_CheckInMask.gameObject, true)
	self.mAnimator:SetTrigger("AutoAccept");

	CS.UITweenManager.PlayScaleTween(self.mTrans_CheckInMask.transform, Vector3(1, 1, 1), Vector3(1, 1,1 ), 0.2, 0, function ()
		-- setactive(self.mTrans_CheckInMask,true)
		-- CS.UITweenManager.PlayFadeTween(self.mTrans_maskImage.transform,0,1,0.5,0.5,nil)
		if callback then
			callback()
		end
	end)
end
