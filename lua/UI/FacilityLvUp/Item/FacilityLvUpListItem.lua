require("UI.UIBaseCtrl")

FacilityLvUpListItem = class("FacilityLvUpListItem", UIBaseCtrl);
FacilityLvUpListItem.__index = FacilityLvUpListItem
--@@ GF Auto Gen Block Begin
FacilityLvUpListItem.mImage_arrow = nil;
FacilityLvUpListItem.mText_Text = nil;
FacilityLvUpListItem.mText_NumBe = nil;
FacilityLvUpListItem.mText_NumAf = nil;

function FacilityLvUpListItem:__InitCtrl()

	self.mImage_arrow = self:GetImage("Image_arrow");
	self.mText_Text = self:GetText("Text_Text");
	self.mText_NumBe = self:GetText("Text_NumBe");
	self.mText_NumAf = self:GetText("Text_NumAf");
end

--@@ GF Auto Gen Block End

function FacilityLvUpListItem:InitCtrl(root)

    local obj=instantiate(UIUtils.GetGizmosPrefab("Facility/FacilityLvUpListItem.prefab",self));

    setparent(root,obj.transform);
    obj.transform.localScale=vectorone;
    self:SetRoot(obj.transform);
	self:__InitCtrl();
end


function FacilityLvUpListItem:SetData(data)
    if data ~=nil then
        setactive(self.mUIRoot.gameObject,true);

        --1等级 2道具产出（速度）3 道具存量 4额外添加 需要另外读表
        if data.type==1 then
            local  facData = TableData.listFacilityDatas:GetDataById(data.paramIntOne);
            self.mText_Text.text=facData.name;
            self.mText_NumBe.text="Lv."..data.paramIntTwo;
        elseif data.type==2 then
            self.mText_Text.text=data.paramStrOne;
            self.mText_NumBe.text = data.paramIntOne;
        elseif data.type==3 then
            self.mText_Text.text=data.paramStrOne;
            self.mText_NumBe.text = data.paramIntOne;
        elseif data.type==4 then
            local  facData = TableData.listPlayerPerkDatas:GetDataById(data.paramIntOne);
            self.mText_Text.text=facData.name;
            self.mText_NumBe.text = data.paramIntTwo;
        else
            gferror("  o  ");
        end


    else
        setactive(self.mUIRoot.gameObject,false);
    end

end


function FacilityLvUpListItem:SetNextData(data)

    if data ~= nil then
        setactive(self.mImage_arrow.gameObject,true);
        setactive(self.mText_NumAf.gameObject,true);
        self.mText_NumAf.text = data.paramIntOne;
        --1等级 2道具产出（速度）3 道具存量 4额外添加 需要另外读表
        if data.type==1 then
            local  facData = TableData.listFacilityDatas:GetDataById(data.paramIntOne);
            self.mText_NumAf.text="Lv."..data.paramIntTwo;
        elseif data.type==2 then
            self.mText_NumAf.text = data.paramIntOne;
        elseif data.type==3 then
            self.mText_NumAf.text = data.paramIntOne;
        elseif data.type==4 then
            self.mText_NumAf.text = data.paramIntTwo;
        else
            gferror("  o  ");
        end
    else
        setactive(self.mImage_arrow.gameObject,false);
        setactive(self.mText_NumAf.gameObject,false);
    end


end




