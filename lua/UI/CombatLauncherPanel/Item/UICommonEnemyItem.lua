require("UI.UIBaseCtrl")

UICommonEnemyItem = class("UICommonEnemyItem", UIBaseCtrl)
UICommonEnemyItem.__index = UICommonEnemyItem

function UICommonEnemyItem:ctor()
	self.rankList = {}
end

function UICommonEnemyItem:__InitCtrl()
	self.mBtn_OpenDetail = self:GetSelfButton()
	self.mImage_Icon = self:GetImage("GrpEnemyIcon/ImgBg/Img_EnemyIcon")
	self.mText_Level = self:GetText("GrpLevel/Text_Level")
	self.mTrans_Level = self:GetRectTransform("GrpLevel")

	for i = 1, 3 do
		local obj = self:GetRectTransform("GrpEnemyRank/Trans_rank" .. i)
		table.insert(self.rankList, obj)
	end
end

function UICommonEnemyItem:InitCtrl(parent)
   local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComEnemyInfoItemV2.prefab", self))
	if parent then
		CS.LuaUIUtils.SetParent(obj.gameObject, parent.gameObject, false)
	end

	self:SetRoot(obj.transform)
	self:__InitCtrl()
end

function UICommonEnemyItem:SetData(code, stageLevel)
	if code then
		self.mImage_Icon.sprite = IconUtils.GetEnemyCharacterHeadSprite(code.character_pic)
		self.mText_Level.text = code.add_level + (stageLevel == nil and 0 or stageLevel)

		for i, obj in ipairs(self.rankList) do
			setactive(obj, i == code.rank)
		end

		setactive(self.mUIRoot, true)
	else
		setactive(self.mUIRoot, false)
	end
end

function UICommonEnemyItem:EnableLv(enable)
	setactive(self.mTrans_Level, enable)
end


