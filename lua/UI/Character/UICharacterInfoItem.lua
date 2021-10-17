require("UI.UIBaseCtrl")

UICharacterInfoItem = class("UICharacterInfoItem", UIBaseCtrl);
UICharacterInfoItem.__index = UICharacterInfoItem
--@@ GF Auto Gen Block Begin

E_PD = CS.GF2.Battle.Property.E_PD
UICharacterInfoItem.m_ShowProps = 
{
    E_PD.pow,
    E_PD.hp,
    E_PD.armor,
    E_PD.max_ap,
    E_PD.crit,
    E_PD.crit_mult,
    E_PD.hit,
    E_PD.dodge,
};

UICharacterInfoItem.GunSkill =
{
    "skill_normal_attack",
    --"skill_super",
    --"skill_active",
    "skill_talent_extra"
}


UICharacterInfoItem.m_SkillDatas = nil;
UICharacterInfoItem.m_SKillIconCtrls = nil;
UICharacterInfoItem.m_SortLayer = 0;

function UICharacterInfoItem:__InitCtrl()

    local item = UICharacterInfoItem.m_ShowProps;

    self.m_AllyInfoTrans = self:GetRectTransform("GrpChrInfo/GrpChrInfo");
    self.m_EnemyInfoTrans = self:GetRectTransform("GrpChrInfo/Trans_GrpEnemyCamp");
    self.m_BuffDescriptionTrans = self:GetRectTransform("Trans_GrpBuff/Trans_GrpBuffDescription");
    self.m_GrpDetailRootTrans = self:GetRectTransform("Trans_GrpDetails")
    self.m_GrpDetailTrans = self:GetRectTransform("Trans_GrpDetails/Trans_GrpDetails")
    self.m_GrpGrpAttributeTrans = self:GetRectTransform("GrpChrInfo/GrpAttribute")
    self.m_GrpGrpTextTrans = self:GetRectTransform("GrpChrInfo/GrpText")
    self.m_GrpTabTrans = self:GetRectTransform("Trans_GrpDetails/Trans_GrpTab/GrpTabSwitch/GrpTab")
    self.m_GrpDetailListTrans = self:GetRectTransform("Trans_GrpDetails/Trans_GrpDetails/GrpDescription/GrpDescriptionList/Viewport/Content")
    self.m_GrpStageTrans = self:GetRectTransform("GrpChrInfo/GrpChrInfo/GrpStage")

    self.m_GunQualityImage = self:GetImage("GrpChrInfo/GrpChrDrawing/GrpLine/ImgLine");
    self.m_AvatarImage = self:GetImage("GrpChrInfo/GrpChrDrawing/GrpChrDrawing/Img_Drawing");
    self.m_ElementGrpTrans = self:GetRectTransform("GrpChrInfo/GrpChrDrawing/GrpElement");
    self.m_MentalLevelImage = self:GetImage("GrpChrInfo/GrpChrInfo/GrpMental/GrpLevel/Img_Level")
    
    self.m_NameText = self:GetText("GrpChrInfo/GrpChrDrawing/GrpTextName/Text_Name");
    self.m_LevelText = self:GetText("GrpChrInfo/GrpChrDrawing/GrpTextLv/Text_Lv");
    self.m_GrpDescriptionText = self:GetText("GrpChrInfo/GrpText/GrpDescription/Viewport/Content/Text_Description");
    self.m_GunTypeText = self:GetText("GrpChrInfo/GrpChrDrawing/GrpWeaponType/Btn_WeaponType/GrpName/Text_Name");
    self.m_SkillRootRect = self:GetRectTransform("GrpChrInfo/GrpSkill/Viewport/Content");
    self.m_AttributeListRect = self:GetRectTransform("GrpChrInfo/GrpAttribute/AttributeList/Viewport/Content");
    self.m_EnemyCampText = self:GetText("GrpChrInfo/Trans_GrpEnemyCamp/GrpName/Text_Name");
    self.m_EnemyCampBtn = self:GetButton("GrpChrInfo/Trans_GrpEnemyCamp/BtnDetails/ComBtn1ItemV2");
    self.m_GuideCloseBtn = self:GetButton("Trans_Btn_GuideClose");

    self.m_BuffEmptyTrans = self:GetRectTransform("Trans_GrpBuff/Trans_GrpBuff/GrpSkillBuff/GrpEmpty");
    self.m_BuffRootTrans =  self:GetRectTransform("Trans_GrpBuff/Trans_GrpBuff");
    self.m_BuffParentTrans = self:GetRectTransform("Trans_GrpBuff/Trans_GrpBuff/GrpSkillBuff/GrpSkill"); 

    self.m_TransGrpDuty = self:GetRectTransform("GrpChrInfo/GrpChrDrawing/GrpDuty")

    UIUtils.GetButtonListener(self.m_EnemyCampBtn.gameObject).onClick = self.OnEnemyCampBtnClick
    UIUtils.GetButtonListener(self.m_GuideCloseBtn.gameObject).onClick = self.OnGuideCloseBtnClick

    self.m_SkillInfoRoot = self:GetRectTransform("Trans_GrpSkillDescription");
          
    self.m_SkillInfoCtrl =  CS.RoleInfoCtrl.SkillInfoCtrl(self.m_SkillInfoRoot);

    self.m_SkillDatas = List:New();
    self.m_SKillIconCtrls = List:New();


    local m_CombatAttributeListItemV2Prefab = ResSys:GetUIGizmos("Combat/CombatAttributeListItemV2.prefab");
    self.m_PropertyInfoCtrls = {};
    for i = 1, 8 do
        local obj = instantiate(m_CombatAttributeListItemV2Prefab, self.m_AttributeListRect);
        local propertyItem = UIUnitPropertyItemV2:New();
        propertyItem:InitCtrl(obj.transform,UICharacterInfoItem.m_ShowProps[i]);
        self.m_PropertyInfoCtrls[i] = propertyItem;
    end

    self.m_ComBtnSkillItemV2Prefab = ResSys:GetUIGizmos("UICommonFramework/ComBtnSkillItemV2.prefab");

end

--@@ GF Auto Gen Block End

function UICharacterInfoItem:InitCtrl(parent)

    local obj=instantiate(UIUtils.GetGizmosPrefab("Combat/CombatChrInfoItemV2.prefab",self));
	--setparent(parent,obj.transform);
    obj.transform:SetParent(parent,false);

	--obj.transform.localScale=vectorone;

	self:SetRoot(obj.transform);

	self:__InitCtrl();

    local anim = obj:GetComponent("Animator");
    anim:SetInteger("Switch",1);

end


function UICharacterInfoItem:UpdateGunPanel(data)
    self.m_BuffRootTrans.gameObject:SetActive(false);
    self:InitGunData(data);
end

function UICharacterInfoItem:UpdateEnemyPanel(data,stageLevel,sortLayer)
	UICharacterInfoItem.m_SortLayer = sortLayer;
    self.m_BuffRootTrans.gameObject:SetActive(false);
    self:InitEnemyData(data, stageLevel);
end

function UICharacterInfoItem:UpdateGunItemPanel(data)
    self.m_BuffRootTrans.gameObject:SetActive(false);

    self:InitGunItemData(nil,data,0,1);
end

function UICharacterInfoItem:TryAddSkill(list, skillID)
    if (skillID ~= 0) then  
        --local skill = TableData.GetSkillData(skillID);
        local skill = TableData.listBattleSkillDatas:GetDataById(skillID)
        if (skill ~= nil) then
            list:Add(CS.RoleInfoCtrl.RoleSkillData(skill));
        end
    end
end

function UICharacterInfoItem:InitSkillList(skillDatas,gunData,weaponId)
    
        --重置icon
        for _, skillIconCtrl in ipairs(self.m_SKillIconCtrls) do
            skillIconCtrl:SetSelected(false);
            skillIconCtrl.gameObject:SetActive(false);
        end

        --统计依附技能
        -- m_EntrySkillDict.Clear();
        -- foreach (RoleSkillData skillData in skillDatas)
        -- {
        --     if (skillData.Data.entry != 0)
        --     {
        --         m_EntrySkillDict.Add(skillData.Data.entry, skillData);
        --     }
        -- }

        -- table.sort(skillDatas, function (a, b) return a.skill_type < b.skill_type end)

        local itemIndex = 0;
        --设置可以显示的技能，并附上附加技能
        for _, skillData in ipairs(skillDatas) do
            if (skillData.Data.skill_in_panel and skillData.Data.entry == 0) then
                local sKillIconCtrl = self:GetOrAddSKillIconCtrl(itemIndex);
                sKillIconCtrl.mUIRoot.gameObject:SetActive(true);

                itemIndex = itemIndex + 1;
                -- local skillGroupID = (skillData.Data.id / 10) * 10;
                -- if (m_EntrySkillDict.TryGetValue(skillGroupID, out RoleSkillData value))
                -- {
                --     sKillIconCtrl.InitData(skillData, value);
                -- }
                -- else
                -- {
                --     sKillIconCtrl.InitData(skillData);
                -- }

                sKillIconCtrl:InitData(skillData,gunData,weaponId);
                UIUtils.GetButtonListener(sKillIconCtrl.m_RootBtn.gameObject).onClick = function()
                    self:ShowSkillDetail(sKillIconCtrl,skillData)
                end
            end
        end
end

function UICharacterInfoItem:GetOrAddSKillIconCtrl(index)
    
    if (self.m_SKillIconCtrls:Count() == index) then
        
        local obj = instantiate(self.m_ComBtnSkillItemV2Prefab, self.m_SkillRootRect, false);
        local ctrl =  UISkillIconCtrl:New();
        ctrl:InitCtrl(obj.transform,self.m_SkillRootRect)
        self.m_SKillIconCtrls:Add(ctrl);
    end     

    return self.m_SKillIconCtrls[index+1];
end

function UICharacterInfoItem:ShowSkillDetail(sender, roleSkillData)
    self.m_SkillInfoCtrl:ShowSkillDetail(roleSkillData);
    for _, ctrl in ipairs(self.m_SKillIconCtrls) do       
        ctrl:SetSelected(ctrl == sender);
    end
end


function UICharacterInfoItem:InitGunItemData(data,gunStcId,upgrade,mental)
    local gunData = TableData.listGunDatas:GetDataById(gunStcId)
    upgrade = gunData.default_grade
    --local dutyData = TableData.listGunDutyDatas:GetDataById(gunData.duty)

    setactive(self.m_GrpDetailRootTrans,true);
    setactive(self.m_GrpDetailTrans,false);

    setactive(self.m_GrpGrpAttributeTrans,false)
    setactive(self.m_GrpGrpTextTrans,true)

    self.mUIRoot.gameObject:SetActive(true);
    self.m_GunTypeText.gameObject:SetActive(true);

    self.m_GrpDescriptionText.text = gunData.introduce.str;
    --头像
    self.m_AvatarImage.sprite = IconUtils.GetCharacterBustSprite(IconUtils.cCharacterAvatarType_Avatar, gunData.code);
    --名字
    self.m_NameText.text = gunData.name.str;
    --等级
    self.m_LevelText.text = string_format(TableData.GetHintDataById(80057).chars.str,"1");

    --枪种
    self.m_GunTypeText.text = TableData.listGunDutyDatas:GetDataById(gunData.duty).abbr.str;
    --元素属性

    local prefab = ResSys:GetUIGizmos("UICommonFramework/ComElementItemV2.prefab");
    local elementItem = instantiate(prefab,self.m_ElementGrpTrans)
    local elementData = TableData.listLanguageElementDatas:GetDataById(gunData.element)
    local elementIcon =  UIUtils.GetImage(elementItem.transform, "Image_ElementIcon")
    elementIcon.sprite = IconUtils.GetElementIconM(elementData.icon);
    --稀有度
    self.m_GunQualityImage.color = TableData.GetGlobalGun_Quality_Color1(gunData.rank);
    self.m_SkillDatas:Clear();

    self:GetSkillDataList(data,gunStcId)

    local weaponId = 0
    if(data ~= nil) then
        weaponId = data.WeaponStcId
    end
    self:InitSkillList(self.m_SkillDatas,gunData,weaponId);

    self.stageItem = UIComStageItemV2:New();
    self.stageItem:InitCtrl(self.m_GrpStageTrans);
    self.stageItem:SetData(upgrade);
    local max = math.max(1,mental)
    self.m_MentalLevelImage.sprite = IconUtils.GetMentalIcon("Img_Mental_number_"..max)

    local dutyData = TableData.listGunDutyDatas:GetDataById(gunData.duty)
    self.dutyItem = UICommonDutyItem.New()
	self.dutyItem:InitCtrl(self.m_TransGrpDuty)
    self.dutyItem:SetData(dutyData);
end

function UICharacterInfoItem:Release()
    if self.stageItem ~= nil then
        self.stageItem:Release()
    end
    self.stageItem = nil
end

function UICharacterInfoItem:GetSkillDataList(data,gunStcId)
    local list = {}
    local TabGunData = nil;
    local grade = 1;
    if(data) then
        TabGunData = data.TabGunData
        grade = data.upgrade
    else
        TabGunData = TableData.listGunDatas:GetDataById(gunStcId)
    end

    table.insert(list, {id = TabGunData.skill_normal_attack, isLock = false, maxLevel = TabGunData.skill_normal_attack})
    for i = 0, TabGunData.grade.Count - 1 do
        local gradeId = TabGunData.grade[i]
        local gradeSkillData = TableData.listGunGradeDatas:GetDataById(gradeId)
        for j = 0, gradeSkillData.abbr.Count - 1 do
            local skill = {}
            local id = gradeSkillData.abbr[j]
            local index, item = tableIsContain(list, function (a) return luaRoundNum(a.id / 10) == luaRoundNum(id / 10 ) end)
            if index == -1 then
                skill.id = id
                skill.isLock = (grade - 1 < i)
                skill.maxLevel = id
                table.insert(list, skill)
            else
                if id > item.id then
                    if grade - 1 >= i  then
                        item.id = id
                        item.isLock = (grade - 1 < i)
                    end
                    item.maxLevel = id
                end
            end
        end
    end
        
    for i=1,#list do
        self:TryAddSkill(self.m_SkillDatas, list[i].id);
    end
    
end

function UICharacterInfoItem:ShowEquipInfo()
    setactive(self.m_GrpDetailTrans,false)
end

function UICharacterInfoItem:ShowUpgradeInfo(gunData)
    setactive(self.m_GrpDetailTrans,true)

    self:InitUpgradePanel(gunData)
end

function UICharacterInfoItem:InitUpgradePanel(gunData)
    local skillList = gunData.grade_skill
    for i = 0, skillList.Length - 1 do
         local item = UIChrInfoItemV2:New();
         item:InitCtrl(self.m_GrpDetailListTrans);
         item:SetData(skillList[i],i)
    end
end

function UICharacterInfoItem:InitEnemyData(enemyData,  level)

    UICharacterInfoItem.m_EnemyData = enemyData;
    setactive(self.m_GrpDetailRootTrans,false);

    setactive(self.m_GrpGrpAttributeTrans,false)
    setactive(self.m_GrpGrpTextTrans,true)

    self.mUIRoot.gameObject:SetActive(true);
    self.m_GunTypeText.gameObject:SetActive(true);

    self.m_GrpDescriptionText.text = enemyData.description.str;
    --头像
    self.m_AvatarImage.sprite = IconUtils.GetCharacterBustSprite(IconUtils.cCharacterAvatarType_Monster, enemyData.character_pic);
    --名字
    self.m_NameText.text = enemyData.name.str;
    --等级
    self.m_LevelText.text = string_format(TableData.GetHintDataById(80057).chars.str,level);
    --枪种
    self.m_GunTypeText.text = TableData.listGunDutyDatas:GetDataById(enemyData.duty).abbr.str;
    --元素属性
    --local elementData = TableData.listLanguageElementDatas:GetDataById(element);
    --self.m_ElementIconImage.sprite = IconUtils.GetElementIconM(elementData.icon);
    --稀有度
    self.m_GunQualityImage.color = TableData.GetGlobalGun_Quality_Color1(1);
    --属性
    local propertyData =  CS.PropertyData(enemyData, level, 0);
    for  i = 1,8 do
        if self.m_PropertyInfoCtrls[i].PropertyType ~= nil then
            local value = propertyData:GetExPropByStrName(self.m_PropertyInfoCtrls[i].PropertyType:ToString());
            self.m_PropertyInfoCtrls[i]:SetValue(value);
        end
    end

    --角色占用格尺寸
    self.m_SkillInfoCtrl:SetOccupySize(enemyData.OccupySize);
    

    --m_EnemyInfoTrans.gameObject:SetActive(true);
    --敌方阵营
    local campData = TableData.listCampDatas:GetDataById(enemyData.enemy_camp);
    self.m_EnemyCampText.text = campData.name.str;
    self.m_AllyInfoTrans.gameObject:SetActive(false);
    self.m_BuffDescriptionTrans.gameObject:SetActive(false);
    self.m_SkillInfoCtrl.gameObject:SetActive(false);
    self.m_EnemyInfoTrans.gameObject:SetActive(enemyData.text_index.Count ~= 0);

    --技能列表
    self.m_SkillDatas:Clear();
    self:TryAddSkill(self.m_SkillDatas, enemyData.SkillNormalAttack);
    self:TryAddSkill(self.m_SkillDatas, enemyData.SkillActive);

    for  i = 0,enemyData.SkillActiveExtra.Length - 1 do
        self:TryAddSkill(self.m_SkillDatas, enemyData.SkillActiveExtra[i]);
    end

    self:TryAddSkill(self.m_SkillDatas, enemyData.SkillSuper);
    self:TryAddSkill(self.m_SkillDatas, enemyData.SkillTalent);

    for i = 0, enemyData.SkillTalentExtra.Length -1 do
        self:TryAddSkill(self.m_SkillDatas, enemyData.SkillTalentExtra[i]);
    end

    self:TryAddSkill(self.m_SkillDatas, enemyData.skill_faction);
    self:TryAddSkill(self.m_SkillDatas, enemyData.skill_faction2);

    self:InitSkillList(self.m_SkillDatas);
end

function UICharacterInfoItem.OnEnemyCampBtnClick()
    UIManager.OpenUIByParam(CS.GF2.UI.enumUIPanel.UIEnemyCampInfoPanel, UICharacterInfoItem.m_EnemyData)

    MessageSys:SendMessage(CS.GF2.Message.UIEvent.SetEnemyCampInfoLayer, null, UICharacterInfoItem.m_SortLayer);
    --UISystem:OpenUI(CS.GF2.UI.enumUIPanel.UIEnemyCampInfoPanel, UICharacterInfoItem.m_EnemyData);
end

function UICharacterInfoItem:InitGunData( data)

    self:InitGunItemData(data,data.Id,data.Grade,data.MentalCircuit)

    --self:GetSkillDataList(data)
    --等级
    self.m_LevelText.text = string_format(TableData.GetHintDataById(80057).chars.str,data.Level);

    
end

