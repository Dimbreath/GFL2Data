require("UI.UIBaseCtrl")

UIGunExpItem = class("UIGunExpItem", UIBaseCtrl)
UIGunExpItem.__index = UIGunExpItem

function UIGunExpItem:ctor()
	self.mData = nil
	self.mParent = nil
	self.offerExp = 0
	self.mCurrentCount = 0
end

function UIGunExpItem:__InitCtrl()
	self.mBtn_Select = self:GetSelfButton()
	self.mBtn_Minus = self:GetButton("Trans_GrpReduce/GrpMinus/ComBtn1ItemV2")
	self.mImage_Icon = self:GetImage("GrpItem/Img_Item")
	self.mImage_Rank = self:GetImage("GrpBg/Img_Bg")
	self.mText_Count = self:GetText("Trans_GrpNum/ImgBg/Text_Num")
	self.mTrans_Select = self:GetRectTransform("GrpSel")
	self.mTrans_UseDetail = self:GetRectTransform("Trans_GrpReduce")
	self.mText_UseCount = self:GetText("Trans_GrpReduce/GrpText/Text_Num")
end

function UIGunExpItem:InitCtrl(parent)
	local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComItemV2.prefab", self))
	if parent then
		CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
	end

	self:SetRoot(obj.transform)
	self:__InitCtrl()
end

function UIGunExpItem:SetData(data)
	self.mData = data
	if data then
		self.mImage_Icon.sprite = UIUtils.GetIconSprite("Icon/Item", data.ItemTableData.icon)
		self.mText_Count.color = data.Num <= 0 and ColorUtils.RedColor or ColorUtils.WhiteColor
		self.mText_Count.text = data.Num
		self.mImage_Rank.sprite=IconUtils.GetQuiltyByRank(data.ItemTableData.rank)
		self.offerExp = data.ItemTableData.args[0]

		setactive(self.mTrans_UseDetail.gameObject, false)

		self:SetSelectedCount(0)
		setactive(self.mUIRoot, true)
	else
		setactive(self.mUIRoot, false)
	end

end

function UIGunExpItem:ResetItem()
	self.mCurrentCount = 0
	self:SetSelectedCount(0)
end

function UIGunExpItem:SetSelectedCount(count)
	if(count == 0) then
		setactive(self.mTrans_UseDetail.gameObject, false)
	else
		setactive(self.mTrans_UseDetail.gameObject, true)
	end

	self.mText_UseCount.text = count
end

function UIGunExpItem:OnClickItem()
	self.mCurrentCount = self.mCurrentCount + 1
	self:SetSelectedCount(self.mCurrentCount)
end

function UIGunExpItem:GetItemExp()
	return self.offerExp * self.mCurrentCount
end

function UIGunExpItem:UpdateData(count)
	self.mCurrentCount = self.mCurrentCount + count
	self:SetSelectedCount(self.mCurrentCount)
end

function UIGunExpItem:UpdateItemNum()
	self.mText_Count.text=self.mData.Num-self.mCurrentCount
end


function UIGunExpItem:OnClickItem(type)
	if type == FacilityBarrackGlobal.PressType.Minus and self.mCurrentCount <= 0 then
		return
	end
	self.mCurrentCount = type == FacilityBarrackGlobal.PressType.Plus and self.mCurrentCount + 1 or self.mCurrentCount - 1
	self:SetSelectedCount(self.mCurrentCount)
end


function UIGunExpItem:IsOutOfNum()
	return self.mCurrentCount >= self.mData.Num
end

function UIGunExpItem:IsItemEnough()
	return self.mData.Num>0
end
function UIGunExpItem:GetItemCount(addCount)
	if self.mCurrentCount + addCount >= self.mData.Num then
		return self.mData.Num - self.mCurrentCount
	else
		return addCount
	end
end

function UIGunExpItem:GetItemAddExp(count)
	count = self.mCurrentCount + count >= self.mData.Num and self.mData.Num - self.mCurrentCount or count
	local addExp = count * self.offerExp
	return addExp
end
