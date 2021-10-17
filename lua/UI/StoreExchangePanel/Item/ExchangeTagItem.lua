require("UI.UIBaseCtrl")

ExchangeTagItem = class("ExchangeTagItem", UIBaseCtrl);
ExchangeTagItem.__index = ExchangeTagItem
--@@ GF Auto Gen Block Begin
ExchangeTagItem.mText_Off_TagName = nil;
ExchangeTagItem.mText_On_TagName = nil;
ExchangeTagItem.mText_Locked_TagName = nil;
ExchangeTagItem.mTrans_Off = nil;
ExchangeTagItem.mTrans_On = nil;
ExchangeTagItem.mTrans_Locked = nil;
ExchangeTagItem.mBtnSelf = nil;

function ExchangeTagItem:__InitCtrl()

	--self.mText_Off_TagName = self:GetText("UI_Trans_Off/Text_TagName");
	self.mText_On_TagName = self:GetText("Text_Name");
	--self.mText_Locked_TagName = self:GetText("UI_Trans_Locked/Text_TagName");
	self.mTrans_Off = self:GetRectTransform("UI_Trans_Off");
	self.mTrans_On = self:GetRectTransform("UI_Trans_On");
	self.mTrans_Locked = self:GetRectTransform("Trans_GrpLocked");

	self.mBtnSelf = self:GetSelfButton();
	 
end

--@@ GF Auto Gen Block End

ExchangeTagItem.mIsLocked = false;
ExchangeTagItem.mData = nil;

function ExchangeTagItem:InitCtrl(parent)

	local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComLeftTab1ItemV2.prefab", self));
	setparent(parent, obj.transform);
	obj.transform.localScale = vectorone;
	obj.transform.localPosition =vectorzero
	self:SetRoot(obj.transform);
	self:__InitCtrl();

end

function ExchangeTagItem:InitData(data)
	self.mData = data;
	self.mText_On_TagName.text = data.name.str;
	--self.mText_Off_TagName.text = data.name.str;
	--self.mText_Locked_TagName.text = data.name.str;

	self.mIsLocked = true;
	local strArr = string.split(data.IncludeTag, ',')
	for _, v in ipairs(strArr) do
		local storeTagData = TableData.listStoreTagDatas:GetDataById(tonumber(v));
		if storeTagData ~= nil and storeTagData.unlock ~= 0 then
			if (AccountNetCmdHandler:CheckSystemIsUnLock(storeTagData.unlock)) then
				self.mIsLocked = false;
			end
		end
		if (storeTagData.unlock == 0) then
			self.mIsLocked = false;
		end
	end

	if data.unlock ~= 0 and not AccountNetCmdHandler:CheckSystemIsUnLock(data.unlock) then
		self.mIsLocked = true;
	end
	

	if(self.mIsLocked) then
        self:SetLocked();
	end

	if self.mIsLocked == true then
		self.mText_On_TagName.color = Color(self.mText_On_TagName.color.r, self.mText_On_TagName.color.g, self.mText_On_TagName.color.b, 160 / 255)
	else
		self.mText_On_TagName.color = Color(self.mText_On_TagName.color.r, self.mText_On_TagName.color.g, self.mText_On_TagName.color.b, 1)
	end
end

function ExchangeTagItem:SetSelect(isSelect)
	if(self.mIsLocked) then
        return;
	end
	--setactive(self.mTrans_Off.gameObject,not isSelect);
	--setactive(self.mTrans_On.gameObject,isSelect);
	self.mBtnSelf.interactable = not isSelect;
	
	
end

function ExchangeTagItem:SetLocked()
	--setactive(self.mTrans_Off.gameObject,false);
	--setactive(self.mTrans_On.gameObject,false);
	setactive(self.mTrans_Locked.gameObject,true);
	 
end