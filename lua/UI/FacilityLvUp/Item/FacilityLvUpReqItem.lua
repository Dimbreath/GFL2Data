require("UI.UIBaseCtrl")

FacilityLvUpReqItem = class("FacilityLvUpReqItem", UIBaseCtrl);
FacilityLvUpReqItem.__index = FacilityLvUpReqItem

FacilityLvUpReqItem.mImage_Notfulfill = nil;
--@@ GF Auto Gen Block Begin
FacilityLvUpReqItem.mText_content = nil;
FacilityLvUpReqItem.mText_Num = nil;
FacilityLvUpReqItem.mTrans_Notfulfill = nil;
FacilityLvUpReqItem.mTrans_goto = nil;

function FacilityLvUpReqItem:__InitCtrl()

	self.mText_content = self:GetText("Text_content");
	self.mText_Num = self:GetText("Text_Num");
	self.mTrans_Notfulfill = self:GetRectTransform("Trans_Notfulfill");
	self.mTrans_goto = self:GetRectTransform("Trans_Notfulfill/Trans_goto");
end

--@@ GF Auto Gen Block End

function FacilityLvUpReqItem:InitCtrl(root)

    local obj=instantiate(UIUtils.GetGizmosPrefab("Facility/FacilityLvUpReqItem.prefab",self));

    setparent(root,obj.transform);
    obj.transform.localScale=vectorone;
    self:SetRoot(obj.transform);

    self:__InitCtrl();

    self.mImage_Notfulfill= self:GetImage("Trans_Notfulfill");
end


function FacilityLvUpReqItem:SetData(data)

    if data ~=nil then
        setactive(self.mUIRoot.gameObject,true);
        setactive(self.mTrans_goto.gameObject,false);

        --1 建材数量 2建筑等级 3.完成任务
        if data.type==1 then
            self.mText_content.text = data.paramStrOne;
            self.mText_Num.text = data.paramIntOne;
            --数量判断

            if data.IsSatisfy==false then
                self.mTrans_Notfulfill.gameObject:SetActive(true);
            else
                self.mTrans_Notfulfill.gameObject:SetActive(false);
            end
        elseif data.type==2 then
            local  facData = TableData.listFacilityDatas:GetDataById(data.paramIntOne);
            self.mText_content.text = facData.name;
            self.mText_Num.text = data.paramIntTwo;
            if data.IsSatisfy==false then
                self.mTrans_Notfulfill.gameObject:SetActive(true);
                setactive(self.mTrans_goto.gameObject,true);
            else
                self.mTrans_Notfulfill.gameObject:SetActive(false);
                setactive(self.mTrans_goto.gameObject,false);
            end
        elseif data.type==3 then


            self.mText_content.text="完成任务";

            if data.IsSatisfy ==false then
                self.mTrans_Notfulfill.gameObject:SetActive(true);
            else
                self.mTrans_Notfulfill.gameObject:SetActive(false);
            end


            local  facData = TableData.listCampaignMissionDatas:GetDataById(data.paramIntOne);

            if facData ~=nil then
                self.mText_Num.text = facData.name;
            else
                gferror("listCampaignMissionDatas缺少ID："..data.paramIntOne);
            end

        else
            gferror("  o  ");
        end


    else

        setactive(self.mUIRoot.gameObject,false);
    end

end

