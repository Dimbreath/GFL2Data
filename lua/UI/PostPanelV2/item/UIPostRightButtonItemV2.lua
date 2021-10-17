require("UI.UIBaseCtrl")

---@class UIPostRightButtonItemV2 : UIBaseCtrl
UIPostRightButtonItemV2 = class("UIPostRightButtonItemV2", UIBaseCtrl);
UIPostRightButtonItemV2.__index = UIPostRightButtonItemV2
--@@ GF Auto Gen Block Begin
UIPostRightButtonItemV2.mBtn_Action = nil;
UIPostRightButtonItemV2.mText_Name = nil;
UIPostRightButtonItemV2.mTrans_OK = nil;

function UIPostRightButtonItemV2:__InitCtrl()

	self.mBtn_Action = self:GetButton("BtnTrans_OK/Btn_Action");
	self.mText_Name = self:GetText("BtnTrans_OK/Btn_Action/Root/GrpText/Text_Name");
	self.mTrans_OK = self:GetRectTransform("BtnTrans_OK");
end

--@@ GF Auto Gen Block End
UIPostRightButtonItemV2.linkURL =nil;
UIPostRightButtonItemV2.linkMethod =nil
UIPostRightButtonItemV2.linkType = 0;

function UIPostRightButtonItemV2:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIPostRightButtonItemV2:SetData(data)
	local linkArgs = data.linkArgs
	self.linkURL = data.linkURL
	self.linkMethod = data.linkMethod
	self.linkType = data.linkType;

	if data.linkType == 1 then
		--setactive(self.mTrans_BG.gameObject,true)
		--setactive(self.mImage_ImageButton.gameObject,false)
		self.mText_Name.text = linkArgs
	else
		--setactive(self.mTrans_BG.gameObject,false)
		--setactive(self.mImage_ImageButton.gameObject,true)
		--self.mBtn_Action.sprite = data.sprite
	end

	UIPostPanelV2.RegisterBtnListener(self,self.mBtn_Action)
end

function UIPostRightButtonItemV2:OnClicked()
	if(self.linkMethod == 1) then
		local switchArray = string.split(self.linkURL,',')
		local paramArray = {tonumber(switchArray[2])}
		SceneSwitch:SwitchByID(tonumber(switchArray[1]),paramArray)
		UIPostPanelV2.Close()
	elseif self.linkMethod == 2 then
		CS.GF2.ExternalTools.Browsers.BrowserHandler.Show(self.linkURL);
	end
end