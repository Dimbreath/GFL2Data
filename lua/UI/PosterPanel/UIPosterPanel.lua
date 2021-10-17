require("UI.UIBasePanel")
require("UI.PosterPanel.UIPosterPanelView")

UIPosterPanel = class("UIPosterPanel", UIBasePanel);
UIPosterPanel.__index = UIPosterPanel;
--UI控件
UIPosterPanel.mView = nil;
UIPosterPanel.mCanvas = nil;
UIPosterPanel.__Opened = false;
UIPosterPanel.callback = nil
function UIPosterPanel:ctor()
    UIPosterPanel.super.ctor(self);
end

function UIPosterPanel.Open(callback)
    if not UIPosterPanel.__Opened then
        if PostInfoConfig.PosterDataList == nil or PostInfoConfig.PosterDataList.Count <= 0 then
            print("没有找到海报数据！请检查请求数据是否返回！")
            if callback then callback() end
            return
        end
        UIPosterPanel.callback = callback
        UIManager.OpenUI(UIDef.UIPosterPanel)
        
    else
        if callback then callback() end
        return
    end
    
end

function UIPosterPanel.Close()
    UIPosterPanel.__Opened = false
    
    
    UIManager.CloseUIByCallback(UIDef.UIPosterPanel, function ()
        if UIPosterPanel.callback then UIPosterPanel.callback() end
    end);
end

function UIPosterPanel.Init(root, data)
    UIPosterPanel.__Opened = true;
    UIPosterPanel.super.SetRoot(UIPosterPanel, root);
    self = UIPosterPanel;

    self.mIsPop = true
    self.mView = UIPosterPanelView;
    self.mView:InitCtrl(root);

    UIUtils.GetButtonListener(self.mView.mBtn_Back.gameObject).onClick = self.OnReturnClick;
    UIUtils.GetButtonListener(self.mView.mBtn_GotoActivity.gameObject).onClick = self.OnGotoActivityClick;

    self.InitContent(PostInfoConfig.PosterDataList);
    self.mCanvas = CS.UnityEngine.GameObject.Find("Canvas");
    
end

function UIPosterPanel.InitContent(posterInfo)
    for i = 0, posterInfo.Count - 1 do
        local posterData = posterInfo[i]
        if string.find(posterData.Image,"https://") == 1 or string.find(posterData.Image,"http://") == 1 then
            --print("try download "..posterInfo.image);
            setactive(UIPosterPanel.mView.mImage_Background.gameObject,false);
            CS.LuaUtils.DownloadTextureFromUrl(posterData.Image,function(tex)
                if not UIPosterPanel.__Opened then
                    return
                end
                setactive(UIPosterPanel.mView.mImage_Background.gameObject,true);
                UIPosterPanel.mView.mImage_Background.sprite = CS.UIUtils.TextureToSprite(tex);
            end)
        end
    end

end

function UIPosterPanel.OnGotoActivityClick(gameObj)
    self = UIPosterPanel;

end

function UIPosterPanel.OnReturnClick(gameObj)
    self = UIPosterPanel;
    self.Close();
end

--[[
function UIPosterPanel.OnRelease()
    self = UIPosterPanel;

end
--]]