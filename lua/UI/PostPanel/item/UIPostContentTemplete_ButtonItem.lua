require("UI.UIBaseCtrl")

UIPostContentTemplete_ButtonItem = class("UIPostContentTemplete_ButtonItem", UIBaseCtrl);
UIPostContentTemplete_ButtonItem.__index = UIPostContentTemplete_ButtonItem
--@@ GF Auto Gen Block Begin
UIPostContentTemplete_ButtonItem.mBtn_ButtonItem = nil;
UIPostContentTemplete_ButtonItem.mImage_ImageButton = nil;
UIPostContentTemplete_ButtonItem.mText_ButtonText = nil;
UIPostContentTemplete_ButtonItem.mTrans_BG = nil;

function UIPostContentTemplete_ButtonItem:__InitCtrl()

	self.mBtn_ButtonItem = self:GetButton("Btn_ButtonItem");
	self.mImage_ImageButton = self:GetImage("Btn_ButtonItem/Image_ImageButton");
	self.mText_ButtonText = self:GetText("Btn_ButtonItem/Trans_BG/Text_ButtonText");
	self.mTrans_BG = self:GetRectTransform("Btn_ButtonItem/Trans_BG");
end

--@@ GF Auto Gen Block End

UIPostContentTemplete_ButtonItem.linkURL =nil;
UIPostContentTemplete_ButtonItem.linkMethod =nil
UIPostContentTemplete_ButtonItem.linkType = 0;

function UIPostContentTemplete_ButtonItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIPostContentTemplete_ButtonItem:SetData(data)
	local linkArgs = data.linkArgs
	self.linkURL = data.linkURL
    self.linkMethod = data.linkMethod
	self.linkType = data.linkType;

	if data.linkType == 1 then
        setactive(self.mTrans_BG.gameObject,true)
		setactive(self.mImage_ImageButton.gameObject,false)
		self.mText_ButtonText.text = linkArgs
	else
        setactive(self.mTrans_BG.gameObject,false)
		setactive(self.mImage_ImageButton.gameObject,true)
		self.mImage_ImageButton.sprite = data.sprite
	end

	UIPostPanel.RegisterBtnListener(self,self.mBtn_ButtonItem)
end

function UIPostContentTemplete_ButtonItem:OnClicked()
	if(self.linkMethod == 1) then
		local switchArray = string.split(self.linkURL,',')
		local paramArray = {tonumber(switchArray[2])}
		SceneSwitch:SwitchByID(tonumber(switchArray[1]),paramArray)
	elseif self.linkMethod == 2 then
		CS.GF2.ExternalTools.Browsers.BrowserHandler.Show(self.linkURL);
	end
end