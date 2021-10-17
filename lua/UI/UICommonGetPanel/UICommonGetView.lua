require("UI.UIBaseView")

UICommonGetView = class("UICommonGetView", UIBaseView)
UICommonGetView.__index = UICommonGetView

function UICommonGetView:ctor()
	self.contentList = {}
end

function UICommonGetView:__InitCtrl()
	self.mBtn_Close = self:GetButton("Root/GrpDialog/GrpTop/GrpClose/Btn_Close")
	self.mBtn_BGClose = self:GetButton("Root/GrpBg/Btn_Close")
	self.mBtn_Confirm = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/GrpAction/BtnConfirm"))
	self.mBtn_Cancel = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/GrpAction/BtnCancel"))
	self.mTextTitle = self:GetText("Root/GrpDialog/GrpCenter/GrpTextTittle/TextName");
	self.mTextInfo = self:GetText("Root/GrpDialog/GrpCenter/GrpTextInfo/Text_Description");
	--self.mImage_ResIcon = self:GetImage("BGPanel/SetaminaDetailPanel/Image_ResourceIcon")
	--self.mText_ResCount = self:GetText("BGPanel/SetaminaDetailPanel/Text_Num")

	self.mTrans_PriceDetails = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_Btn_PriceDetails")
	self.mImg_PriceDetailsImageIcon = self:GetImage("Root/GrpDialog/GrpCenter/Trans_Btn_PriceDetails/GrpItemIcon/Img_Icon")
	self.mTxt_PriceSetailsNum = self:GetText("Root/GrpDialog/GrpCenter/Trans_Btn_PriceDetails/Text_Num")
	self.mBtn_PriceDetails = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_Btn_PriceDetails/BtnInfo"))

	self.mTrans_GrpPriceDetails = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpPriceDetails")
	self.mTrans_GrpPriceDetailsContent = self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpPriceDetails/GrpAllSkillDescription/GrpDescribe/Viewport/Content")
	self.mBtn_GrpPriceDetails = UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/GrpCenter/Trans_GrpPriceDetails/BtnInfo"))

	self.mTxt_TextNum = self:GetText("Root/GrpDialog/GrpCenter/GrpTextInfo/Trans_GrpTextNum/Text_Num")
	self.mTrans_TextNum = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpTextInfo/Trans_GrpTextNum")

	for i = 1, 2 do
		local obj = self:GetRectTransform("Root/GrpDialog/GrpCenter/GrpItemList/Content/ComItemV2_" .. i)
		local contetn = self:InitContent(obj, i)
		table.insert(self.contentList, contetn)
	end
end


function UICommonGetView:InitCtrl(root)
	self:SetRoot(root)
	self:__InitCtrl()
end

function UICommonGetView:InitContent(obj, index)
	local content = {}
	local transItem = obj
	content.type = index
	content.item = transItem
	--content.btnGet = UIUtils.GetRectTransform(obj, "Btn_GetButton")
	--content.transCan = UIUtils.GetRectTransform(obj, "Btn_GetButton/Trans_Can")
	--content.transNotEnough = UIUtils.GetRectTransform(obj, "Btn_GetButton/Trans_Short")
	--content.transFull = UIUtils.GetRectTransform(obj, "Btn_GetButton/Trans_Full")
	content.imgIcon = UIUtils.GetImage(obj, "GrpItem/Img_Item")
	--content.txtCost = UIUtils.GetText(obj, "Btn_GetButton/CostMessage/Text_Cost")
	--content.imgRemainItem = UIUtils.GetImage(obj, "UI_RemainItems/Image_SetaminaIcon")
	content.txtRemainItem = UIUtils.GetText(obj, "Trans_GrpNum/ImgBg/Text_Num")
	content.transChoose = UIUtils.GetRectTransform(obj, "Trans_GrpChoose")
	content.tranSel = UIUtils.GetRectTransform(obj, "GrpSel")
	content.imgRank = UIUtils.GetImage(obj, "GrpBg/Img_Bg")
	content.btnSelect =  CS.LuaUIUtils.GetButton(transItem)

	local btn = UIUtils.GetButtonListener(content.btnSelect.gameObject);
    btn.onClick = UICommonGetPanel.OnSelectItem;
    btn.param = index;

	--content.item:InitItem(transItem.gameObject)

	return content
end