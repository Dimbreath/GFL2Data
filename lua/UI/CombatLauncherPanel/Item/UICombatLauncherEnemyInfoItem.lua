require("UI.UIBaseCtrl")

UICombatLauncherEnemyInfoItem = class("UICombatLauncherEnemyInfoItem", UIBaseCtrl);
UICombatLauncherEnemyInfoItem.__index = UICombatLauncherEnemyInfoItem
--@@ GF Auto Gen Block Begin
UICombatLauncherEnemyInfoItem.mImage_MiniPortraitBG = nil;
UICombatLauncherEnemyInfoItem.mImage_MiniPortrait = nil;
UICombatLauncherEnemyInfoItem.mImage_MiniPortraitNameBG = nil;
UICombatLauncherEnemyInfoItem.mText_EnemyName = nil;
UICombatLauncherEnemyInfoItem.rankList = {}

function UICombatLauncherEnemyInfoItem:__InitCtrl()
	self.mBtn_OpenDetail = self:GetButton("Btn_OpenDetail")
	self.mImage_MiniPortraitBG = self:GetImage("Image_MiniPortraitBG");
	self.mImage_MiniPortrait = self:GetImage("Image_MiniPortraitMask/Image_MiniPortrait");
	self.mImage_MiniPortraitNameBG = self:GetImage("Image_MiniPortraitNameBG");
	self.mText_EnemyName = self:GetText("Text_EnemyName");
	self.mText_Level = self:GetText("Level/Text_Number")
	self.mImage_LevelBg = self:GetImage("MiniPortraitLevelBG/Image_LevelBGImage")
	self.mImage_Line = self:GetImage("MiniPortraitLevelBG/Image_Line")

	self.rankList = {}
	for i = 1, 3 do
		local obj = self:GetRectTransform("EnemyRank/Trans_rank" .. i)
		table.insert(self.rankList, obj)
	end
end

--@@ GF Auto Gen Block End

function UICombatLauncherEnemyInfoItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UICombatLauncherEnemyInfoItem:InitData(code, stageLevel)
	if code == nil then
		setactive(self.mUIRoot, false)
		return
	end
	local sprite = IconUtils.GetCharacterHeadSprite(code.character_pic);
	if sprite == nil then
		gferror("找不到敌人图标"..code.character_pic);
	else
		self.mImage_MiniPortrait.sprite = sprite;
	end
	self.mImage_Line.color = self:GetColorByElement(code.element)
	self.mImage_LevelBg.color = self:GetColorByElement(code.element)
	self.mText_Level.text = code.add_level + (stageLevel == nil and 0 or stageLevel)
	self.mText_EnemyName.text = code.name.str
	for i, obj in ipairs(self.rankList) do
		setactive(obj, i == code.rank)
	end
	setactive(self.mUIRoot, true)
end

function UICombatLauncherEnemyInfoItem:GetColorByElement(element)
	local color = ""
	if element == 1 then
		color = "0dbb57"
	elseif element == 2 then
		color = "f44f13"
	elseif element == 3 then
		color = "3472ef"
	elseif element == 4 then
		color = "8634ff"
	elseif element == 5 then
		color = "ebb702"
	elseif element == 6 then
		color = "000000"
	end
	return CS.GF2.UI.UITool.StringToColor(color)
end