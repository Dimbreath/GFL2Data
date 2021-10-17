require("UI.UIBaseCtrl")

UIChipConsumeItem = class("UIChipConsumeItem", UIBaseCtrl);
UIChipConsumeItem.__index = UIChipConsumeItem
--@@ GF Auto Gen Block Begin
UIChipConsumeItem.mImage_LevelUp_ChipRank = nil;
UIChipConsumeItem.mImage_LevelUp_ChipIcon = nil;
UIChipConsumeItem.mText_LevelUp_Name = nil;
UIChipConsumeItem.mText_LevelUp_Level = nil;
UIChipConsumeItem.mTrans_LevelUp_Material = nil;

function UIChipConsumeItem:__InitCtrl()

	self.mImage_LevelUp_ChipRank = self:GetImage("Trans_Material/Image_ChipRank");
	self.mImage_LevelUp_ChipIcon = self:GetImage("Trans_Material/Image_ChipRank/Image_ChipIcon");
	self.mText_LevelUp_Name = self:GetText("Trans_Material/NameBG/Text_Name");
	self.mText_LevelUp_Level = self:GetText("Trans_Material/Text_Level");
	self.mTrans_LevelUp_Material = self:GetRectTransform("Trans_Material");
end

--@@ GF Auto Gen Block End

function UIChipConsumeItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UIChipConsumeItem:InitData(chipId)
	local data = NetCmdChipData:GetChipById(chipId);
	if(data == nil) then
		return;
	end

	self.mImage_LevelUp_ChipRank.color = TableData.GetGlobalGun_Quality_Color2(data.StcData.rank);
	self.mText_LevelUp_Name.text = data.StcData.name.str;
	self.mText_LevelUp_Level.text = "Lv."..data.CurLv;
end