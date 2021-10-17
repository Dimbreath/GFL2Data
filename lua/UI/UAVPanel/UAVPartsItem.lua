require("UI.UIBaseCtrl")

UAVPartsItem = class("UAVPartsItem", UIBaseCtrl);
UAVPartsItem.__index = UAVPartsItem
UAVPartsItem.mBtn_Unique=nil
UAVPartsItem.mTrans_Set=nil
UAVPartsItem.mTrans_SkillIcon=nil
UAVPartsItem.mTrans_Add=nil
UAVPartsItem.mTrans_Lock=nil
UAVPartsItem.mTrans_RedPoint=nil
UAVPartsItem.mImage_LeftUpIcon=nil
UAVPartsItem.mImage_SkillIcon=nil
UAVPartsItem.mText_CostNum=nil
UAVPartsItem.mText_SkillLevelNum=nil
UAVPartsItem.mText_UnLockLevelNum=nil
UAVPartsItem.mUavView=nil
UAVPartsItem.armtabledata=nil
UAVPartsItem.armskilltabledata=nil
UAVPartsItem.uavarmdic=nil
UAVPartsItem.armequipstate=nil
UAVPartsItem.callback=nil
UAVPartsItem.IsClickEmpty=false
function UAVPartsItem:__InitCtrl(view)

    self.IsClickEmpty=false
    self.mBtn_Unique=self:GetSelfButton()
    self.mTrans_Set=self:GetRectTransform("GrpSel")
    self.mTrans_SkillIcon=self:GetRectTransform("Trans_GrpItem")
    self.mTrans_Add=self:GetRectTransform("Trans_GrpAdd")
    self.mTrans_Lock=self:GetRectTransform("Trans_GrpLock")
    self.mTrans_RedPoint=self:GetRectTransform("Trans_RedPoint")
    self.mImage_LeftUpIcon=self:GetImage("Trans_GrpItem/GrpTacticSkill2DIcon/Img_Icon")
    self.mImage_SkillIcon=self:GetImage("Trans_GrpItem/Grp3DModel/Img_3DModelIcon")
    self.mText_CostNum=self:GetText("Trans_GrpItem/GrpCost/Text_Num")
    self.mText_SkillLevelNum=self:GetText("Trans_GrpItem/GrpLevel/Text_Num")
    self.mText_UnLockLevelNum=self:GetText("Trans_GrpLock/GrpLevel/Text_Num")
    self.mTrans_ArmLock=self:GetRectTransform("Trans_GrpItem/Trans_GrpLock")
    self.mUavView=view
    self.armtabledata=TableData.GetUavArmsData()
    self.uavarmdic=NetCmdUavData:GetUavArmData()
    self.armequipstate=NetCmdUavData:GetArmEquipState()


    -- self.tabledata=List.New()
    -- self.tabledata=TableData.GetUavArmsData()
    
    -- self.uavarmdic=Dictionary.New()
    -- self.uavarmdic=NetCmdUavData.GetUavArmData()

end

--@@ GF Auto Gen Block End

function UAVPartsItem:InitCtrl(root,view)

	self:SetRoot(root)

	self:__InitCtrl(view)

end

function UAVPartsItem:InitData(data,State,index,IsShowRedPoint)
    
    if State==true then
        if data~=0 then
            if UAVUtility.NowFakeBottomArmId==data and UAVUtility.NowBottomPos==index  then
                self.mBtn_Unique.interactable=false
            end
            if self.uavarmdic:ContainsKey(data)==false then
                setactive(self.mTrans_ArmLock,true)
            else
                setactive(self.mTrans_ArmLock,false)
            end
            local smallicondata=TableData.GetUarArmRevelantData(tonumber(self.armtabledata[data].SkillSet))
            setactive(self.mTrans_SkillIcon,true)
            self.mImage_LeftUpIcon.sprite=UIUtils.GetIconSprite("Icon/Skill",smallicondata.Icon);
            self.mImage_SkillIcon.sprite=UIUtils.GetIconSprite("Icon/UAV3DModelIcon","Icon_UAV3DModelIcon_"..self.armtabledata[data].ResCode);
            self.mText_CostNum.text=self.armtabledata[data].Cost
            local nowlevel=0
            if self.uavarmdic:ContainsKey(data)==false then
                nowlevel=1
            else
                nowlevel=self.uavarmdic[data].Level
            end
            self.mText_SkillLevelNum.text="Lv."..nowlevel
            setactive(self.mTrans_Set,false)
            setactive(self.mTrans_Add,false)
            setactive(self.mTrans_Lock,false)
            --setactive(self.mTrans_RedPoint,false)  
            UIUtils.GetButtonListener(self.mBtn_Unique.gameObject).onClick=function() 
                
                local isfirst=true
                self.OnClickBtn(data,self.mUavView,index,isfirst)
            end
            if IsShowRedPoint then
                setactive(self.mTrans_RedPoint,true) 
                local script=self.mTrans_RedPoint:GetComponent(typeof(CS.ScrollListChild))
                local itemobj=instantiate(script.childItem.gameObject,self.mTrans_RedPoint)
            end
        else
            if UAVUtility.NowFakeBottomArmId==data and  UAVUtility.NowBottomPos==index then
                self.mBtn_Unique.interactable=false
            end
            setactive(self.mTrans_Add,true)
            setactive(self.mTrans_Lock,false)
            setactive(self.mTrans_SkillIcon,false)
            setactive(self.mTrans_Set,false)
            UIUtils.GetButtonListener(self.mBtn_Unique.gameObject).onClick=function() 
                local isfirst=false
                self.OnClickBtn(data,self.mUavView,index,isfirst)
            end
        end
    else
        UIUtils.GetButtonListener(self.mBtn_Unique.gameObject).onClick=function() 
            self.OnClickLockBtn(index)
        end
        setactive(self.mTrans_Lock,true)
        if data==2 then
            self.mText_UnLockLevelNum.text="Lv.10"
        elseif data==3 then
            self.mText_UnLockLevelNum.text="Lv.20"
        end
        setactive(self.mTrans_Add,false)
        setactive(self.mTrans_SkillIcon,false)
        setactive(self.mTrans_Set.gameObject,false)
    end
end

function UAVPartsItem.OnClickLockBtn(pos)
    self=UAVPartsItem
    
    if pos==1 then
        local hint1=TableData.GetHintById(105018)
        CS.PopupMessageManager.PopupString(string_format(hint1,10))
    end
    if pos==2 then
        local hint2=TableData.GetHintById(105018)
        CS.PopupMessageManager.PopupString(string_format(hint2,20))
    end

end

function UAVPartsItem.OnClickBtn(armid,UavView,pos)
    self=UAVPartsItem
    --UIUAVPanel.UpOrDown(false)
    
    UAVUtility.NowArmId=armid
    UAVUtility.NowRealBottomArmId=armid
    UAVUtility.NowFakeBottomArmId=armid
    UAVUtility.NowBottomPos=pos
    if  armid==0 then
        UAVUtility.AniState=0
    else
        UAVUtility.AniState=1
    end
    local armequipstate=NetCmdUavData:GetArmEquipState()

    if UavView.mTrans_UAVPartsInfo.gameObject.activeSelf==false then
        UAVUtility.OnlyRefreshOnce=true
    end
    --2是进来 3是出去
    if UavView.mTrans_UAVPartsInfo.gameObject.activeSelf then
        if UAVUtility.AniState~=0 then
            setactive(UavView.mTrans_RightSKiillInfo,true)
            UavView.mAnimator:SetInteger("UAVInfo",2)
            
        elseif UAVUtility.AniState==0 then
            setactive(UavView.mTrans_RightSKiillInfo,true)
            UavView.mAnimator:SetInteger("UAVInfo",3)
          
        end
    end

    
    local pos=UavView.mTrans_ScrollContent.localPosition
    UavView.mTrans_ScrollContent.localPosition=Vector3(pos.x,0,pos.z)
    UavView.mCanvas_ScrollBar.alpha=1
    UIUAVPanel.UpdateLeftAreaInfo(true)
    --UavView.mCanvas_ScrollBar.alpha=1
    UIUAVPanel.UpdateBottomSkillState()
    UIUAVPanel.UpdateRightAreaInfo()
    if UavView.mTrans_UAVInfo.gameObject.activeSelf then
        UavView.mAnimator:SetInteger("List",4)
        UavView.mAnimator:SetInteger("UAVInfo",1)
        TimerSys:DelayCall(0.33,function ()
            setactive(UavView.mTrans_UAVInfo,false)
            setactive(UavView.mTrans_UAVPartsInfo,true)
            setactive(UavView.mTrans_LeftSkillList,true)
            if UAVUtility.AniState==1 then
                setactive(UavView.mTrans_RightSKiillInfo,true)
                UavView.mAnimator:SetInteger("UAVInfo",2)
            elseif UAVUtility.AniState==0 then
                setactive(UavView.mTrans_RightSKiillInfo,false)
            end
        end)
    end
end


