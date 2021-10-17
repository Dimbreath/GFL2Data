require("UI.UIBaseCtrl")

UISimCombatMythicBuffItem = class("UISimCombatMythicBuffItem", UIBaseCtrl);
UISimCombatMythicBuffItem.__index = UISimCombatMythicBuffItem
--@@ GF Auto Gen Block Begin
UISimCombatMythicBuffItem.mImage_BuffIcon = nil;
UISimCombatMythicBuffItem.mText_BuffName = nil;
UISimCombatMythicBuffItem.mText_BuffDescription = nil;

function UISimCombatMythicBuffItem:__InitCtrl()

	self.mImage_BuffIcon = self:GetImage("Image_BuffIcon");
	self.mText_BuffName = self:GetText("Text_BuffName");
	self.mText_BuffDescription = self:GetText("Text_BuffDescription");
end

--@@ GF Auto Gen Block End
UISimCombatMythicBuffItem.mBuffId =nil;
function UISimCombatMythicBuffItem:InitCtrl(root)

	self:SetRoot(root);

	self:__InitCtrl();

end

function UISimCombatMythicBuffItem:SetData(buffId,buffLevel)
	self.mBuffId = buffId
	local mythicBuffData = TableData.listSimCombatMythicBuffDatas:GetDataById(buffId);
	if  mythicBuffData ~=nil then
		self.mImage_BuffIcon.sprite = IconUtils.GetSkillIconSprite(mythicBuffData.Icon)
		local skillData = TableData.GetGroupSkill(mythicBuffData.SkillId, buffLevel)
		if  skillData ~=nil then
			self.mText_BuffName.text = skillData.Name.str;
			self.mText_BuffDescription.text =skillData.Description.str;
		end
	end
end 