require("UI.UIBaseCtrl")

SkillPUmatItem = class("SkillPUmatItem", UIBaseCtrl);
SkillPUmatItem.__index = SkillPUmatItem
--@@ GF Auto Gen Block Begin
SkillPUmatItem.mImage_rank = nil;
SkillPUmatItem.mText_SkillName = nil;
SkillPUmatItem.mText_lv = nil;

SkillPUmatItem._CachePrefab = nil;

function SkillPUmatItem:__InitCtrl()

	self.mImage_rank = self:GetImage("Image_rank");
	self.mText_SkillName = self:GetText("Text_SkillName");
	self.mText_lv = self:GetText("Text_lv");
	
end

--@@ GF Auto Gen Block End

function SkillPUmatItem:InitCtrl(root)

	if(SkillPUmatItem._CachePrefab == nil) then
		SkillPUmatItem._CachePrefab = UIUtils.GetGizmosPrefab("SkillCore/SkillPUmatItem.prefab",self);
	end	
	local obj=instantiate(SkillPUmatItem._CachePrefab);
	
	setparent(root,obj.transform);
	obj.transform.localScale=vectorone;
	
	self:SetRoot(obj.transform);
	self:__InitCtrl();

end

function SkillPUmatItem:SetData(data)
	if data == nil then
		setactive(self.mUIRoot,false);
	else		
		local stcData = TableData.GetSkillCoreDataById(data.stc_id);	
		self.mText_lv.text = data.level;
		self.mText_SkillName.text = TableData.GetSkillCoreSkillNameById(stcData.id);
		self.mImage_rank.color = TableData.GetGlobalGun_Quality_Color2(stcData.rank);
		setactive(self.mUIRoot,true);
	end
end