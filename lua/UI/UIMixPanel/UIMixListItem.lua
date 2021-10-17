require("UI.UIBaseCtrl")

UIMixListItem = class("UIMixListItem", UIBaseCtrl);
UIMixListItem.__index = UIMixListItem
--@@ GF Auto Gen Block Begin
UIMixListItem.mBtn_ComItem = nil;
UIMixListItem.mImage_Bg = nil;
UIMixListItem.mImage_Item = nil;
UIMixListItem.mText_Num = nil;
UIMixListItem.mText_First = nil;
UIMixListItem.mText_Name = nil;
UIMixListItem.mText_AmountNum = nil;
UIMixListItem.mTrans_GrpNum = nil;
UIMixListItem.mTrans_GrpFirst = nil;

UIPostPanelView.animator = nil

function UIMixListItem:__InitCtrl()

	self.mBtn_ComItem = self:GetButton("GrpNor/GrpItem/Btn_ComItem");
	self.mImage_Bg = self:GetImage("GrpNor/GrpItem/Btn_ComItem/GrpBg/Img_Bg");
	self.mImage_Item = self:GetImage("GrpNor/GrpItem/Btn_ComItem/GrpItem/Image_Item");
	self.mText_Num = self:GetText("GrpNor/GrpItem/Btn_ComItem/Trans_GrpNum/ImgBg/Text_Num");
	self.mText_First = self:GetText("GrpNor/GrpItem/Btn_ComItem/Trans_GrpFirst/Img_Bg/Text_First");
	self.mText_Name = self:GetText("GrpNor/GrpText/Text_Name");
	self.mText_AmountNum = self:GetText("GrpNor/GrpText/Text_AmountNum");
	self.mTrans_GrpNum = self:GetRectTransform("GrpNor/GrpItem/Btn_ComItem/Trans_GrpNum");
	self.mTrans_GrpFirst = self:GetRectTransform("GrpNor/GrpItem/Btn_ComItem/Trans_GrpFirst");

end

--@@ GF Auto Gen Block End

function UIMixListItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

--@@ GF Auto Gen Block End


UIMixListItem.mData = nil;

--function UIMixListItem:InitCtrl()
--
--
--	local itemPrefab = UIUtils.GetGizmosPrefab("Character/BarrackMentalComposeItemV2.prefab", self)
--	local instObj = instantiate(itemPrefab)
--	
--	self:SetRoot(instObj.transform)
--	self:__InitCtrl();
--
--end


function UIMixListItem:SetData(item,isSelect)
	self.mData = item;
	--UIUtils.GetButtonListener(self.mBtn_BG.gameObject).onClick = function()
	--	UIMixListItem:OnClickItem()
	--end

	self.mText_AmountNum.text = tostring(NetCmdItemData:GetResCount(item.itemId))
	local itemData = TableData.listItemDatas:GetDataById(item.itemId);
	if itemData ~= nil then
		self.mImage_Item.sprite = IconUtils.GetItemSprite(itemData.icon)
		self.mImage_Bg.sprite = IconUtils.GetQuiltyByRank(itemData.rank)
		self.mText_Name.text = itemData.name.str
	end
	if isSelect == true then
		self:GetSelfButton().interactable = false;
	else
		self:GetSelfButton().interactable = true;
	end
	
	setactive(self.mTrans_GrpNum,false)
end
