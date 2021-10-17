require("UI.UIBaseCtrl")

UIUavExpItem = class("UIUavExpItem", UIBaseCtrl)
UIUavExpItem.__index = UIUavExpItem

function UIUavExpItem:ctor()
	self.mData = nil
	self.mParent = nil
	self.offerExp = 0
	self.mCurrentCount = 0
end

function UIUavExpItem:__InitCtrl()
	self.mBtn_Select = self:GetSelfButton()
	self.mBtn_Minus = self:GetButton("Trans_GrpReduce/GrpMinus/ComBtn1ItemV2")
	self.mImage_Icon = self:GetImage("GrpItem/Img_Item")
	self.mImage_Rank = self:GetImage("GrpBg/Img_Bg")
	self.mText_Count = self:GetText("Trans_GrpNum/ImgBg/Text_Num")
	self.mTrans_Select = self:GetRectTransform("GrpSel")
	self.mTrans_UseDetail = self:GetRectTransform("Trans_GrpReduce")
	self.mText_UseCount = self:GetText("Trans_GrpReduce/GrpText/Text_Num")
end

function UIUavExpItem:InitCtrl(parent)
	local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComItemV2.prefab", self))
	if parent then
		CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
	end

	self:SetRoot(obj.transform)
	self:__InitCtrl()
end

function UIUavExpItem:SetData(data)
	self.mData = data
	if data then
		self.mImage_Icon.sprite = UIUtils.GetIconSprite("Icon/Item", data.ItemTableData.icon)
		self.mText_Count.color = data.Num <= 0 and ColorUtils.RedColor or ColorUtils.WhiteColor
		self.mText_Count.text = data.Num
		self.offerExp = data.ItemTableData.args[0]
		self.mImage_Rank.sprite=IconUtils.GetQuiltyByRank(data.ItemTableData.rank)

		setactive(self.mTrans_UseDetail.gameObject, false)

		self:SetSelectedCount(0)
		setactive(self.mUIRoot, true)
	else
		setactive(self.mUIRoot, false)
	end

end

function UIUavExpItem:ResetItem()
	self.mCurrentCount = 0
	self:SetSelectedCount(0)
end

function UIUavExpItem:SetSelectedCount(count)
	if(count == 0) then
		setactive(self.mTrans_UseDetail.gameObject, false)
	else
		setactive(self.mTrans_UseDetail.gameObject, true)
	end

	self.mText_UseCount.text = count
end

function UIUavExpItem:OnClickItem()
	self.mCurrentCount = self.mCurrentCount + 1
	self:SetSelectedCount(self.mCurrentCount)
end

function UIUavExpItem:GetItemExp()
	return self.offerExp * self.mCurrentCount
end

function UIUavExpItem:UpdateData(count)
	self.mCurrentCount = self.mCurrentCount + count
	self:SetSelectedCount(self.mCurrentCount)
end

function UIUavExpItem:UpdateItemNum()
	self.mText_Count.text=self.mData.Num-self.mCurrentCount
	self.mText_Count.color = self.mData.Num-self.mCurrentCount <= 0 and ColorUtils.RedColor or ColorUtils.WhiteColor
end


function UIUavExpItem:OnClickItem(type)
	if type == FacilityBarrackGlobal.PressType.Minus and self.mCurrentCount <= 0 then
		return
	end
	self.mCurrentCount = type == FacilityBarrackGlobal.PressType.Plus and self.mCurrentCount + 1 or self.mCurrentCount - 1
	self:SetSelectedCount(self.mCurrentCount)
end


function UIUavExpItem:IsOutOfNum()
	return self.mCurrentCount >= self.mData.Num
end

function UIUavExpItem:IsItemEnough()
	return self.mData.Num>0
end
function UIUavExpItem:GetItemCount(addCount)
	if self.mCurrentCount + addCount >= self.mData.Num then
		return self.mData.Num - self.mCurrentCount
	else
		return addCount
	end
end

function UIUavExpItem:ReturnCurCount()
	return self.mCurrentCount
end


function UIUavExpItem:GetItemAddExp(count)
	count = self.mCurrentCount + count >= self.mData.Num and self.mData.Num - self.mCurrentCount or count
	local addExp = count * self.offerExp
	return addExp
end
