require("UI.UIBasePanel")
require("UI.UniTopbar.UIUniTopbarView")
require("UI.UniTopbar.Item.ResourcesCommonItem")
require("UI.UniTopbar.Item.UISystemCommonItem")

UIStoreExchangePriceChangeDialog = class("UIStoreExchangePriceChangeDialog",UIBasePanel)
UIStoreExchangePriceChangeDialog.__index = UIStoreExchangePriceChangeDialog

UIStoreExchangePriceChangeDialog.mView = nil

UIStoreExchangePriceChangeDialog.mCurrencyItemList = {}
UIStoreExchangePriceChangeDialog.mStaminaItemList = {}

UIStoreExchangePriceChangeDialog.mSystemItemList = {}

function  UIStoreExchangePriceChangeDialog:ctor()
    UIStoreExchangePriceChangeDialog.super.ctor(self)
end

function  UIStoreExchangePriceChangeDialog.Open()
    UIManager.OpenUI(UIDef.UIStoreExchangePriceChangeDialog)
end

function  UIStoreExchangePriceChangeDialog.Close()
    UIManager.CloseUI(UIDef.UIStoreExchangePriceChangeDialog)
end

function  UIStoreExchangePriceChangeDialog.OnShow()
    UIStoreExchangePriceChangeDialog.mUIRoot.transform:SetAsLastSibling()
end

function  UIStoreExchangePriceChangeDialog.Init(root, data)
    UIStoreExchangePriceChangeDialog.super.SetRoot(UIStoreExchangePriceChangeDialog, root);

    self = UIStoreExchangePriceChangeDialog;

    self.mData = data;
    self.mIsPop = true

    self.mView = UIStoreExchangePriceChangeDialogView;
    self.mView:InitCtrl(root);

    UIUtils.GetButtonListener(self.mView.mBtn_Close.gameObject).onClick = function()
        UIStoreExchangePriceChangeDialog.Close()
    end

    UIUtils.GetButtonListener(self.mView.mBtn_Confirm.gameObject).onClick = function()
        UIStoreExchangePriceChangeDialog.Close()
    end
end

function  UIStoreExchangePriceChangeDialog:SetData()

    self:InitIcon();

    local nextData = NetCmdStoreData:GetStoreGoodById(self.mData.jump_id);


    if(nextData.limit > 0) then
        local hint = TableData.GetHintById(106007);
        local msg = string_format(hint,self.mData.MultiBuyTimes,nextData.limit)
        self.mView.mText_Description.text = msg;
    else
        local hint = TableData.GetHintById(106010);
        local msg = string_format(hint,self.mData.MultiBuyTimes)
        self.mView.mText_Description.text = msg;
    end


    self.mView.mText_PriceNum1.text = self.mData.price;
    self.mView.mText_PriceNum2.text = nextData.price;

    local currency = TableData.GetItemData(self.mData.price_type);
    self.mView.mImage_PriceIcon1.sprite = UIUtils.GetIconSprite("Icon/Item",currency.icon);
    self.mView.mImage_PriceIcon2.sprite = UIUtils.GetIconSprite("Icon/Item",currency.icon);
end

function  UIStoreExchangePriceChangeDialog:InitIcon()
    self = UIStoreExchangePriceChangeDialog;
    local data = self.mData;
    
    local item = UICommonItem.New()
    item:InitCtrl(self.mView.mTrans_IconRoot)
    item:SetItemData(data.ItemNumList[0].itemid)
end


-- function  UIStoreExchangePriceChangeDialog:InitIcon()
--     self = UIStoreExchangePriceChangeDialog;
--     local data = self.mData;
--     local stcData = TableData.GetItemData(data.frame,true);

--     local sprite = nil;
--     local bg_sprite = nil;
-- 	if data.frame ~= 0 and stcData ~= nil and stcData.type == 5 then

-- 		--- 模组图标显示
-- 		local equipData = TableData.GetEquipData(stcData.args[0])
-- 		if data.icon ~= "" then
-- 			sprite =  IconUtils.GetItemIcon(data.icon.."_1");
-- 		else
-- 			sprite =  IconUtils.GetEquipSprite(equipData.res_code.."_1");
-- 		end
-- 		bg_sprite = IconUtils.GetQuiltyByRank(equipData.rank);
-- 		--- 模组图标显示
-- 	elseif data.frame ~= 0 and stcData ~= nil and stcData.type == 8 then
-- 		local weaponData = TableData.listGunWeaponDatas:GetDataById(stcData.args[0]);
-- 		if weaponData ~= nil then
-- 			if data.icon ~= "" then
-- 				sprite =  IconUtils.GetItemIcon(data.icon.."_s");
-- 			else
-- 				sprite = IconUtils.GetWeaponSprite(weaponData.res_code)
-- 			end

--             bg_sprite = IconUtils.GetWeaponQuiltyByRank(data.rank);
-- 		end
-- 	else
-- 		if  data.icon ~= "" then
-- 			sprite =  IconUtils.GetItemIcon(data.icon)
-- 		else
-- 			sprite =  IconUtils.GetItemIcon(stcData.icon)
-- 		end

--         bg_sprite = IconUtils.GetQuiltyByRank(data.rank);
-- 	end

--     local obj = instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/ComItemV2.prefab", self))
-- 	CS.LuaUIUtils.SetParent(obj.gameObject, self.mView.mTrans_IconRoot.gameObject, true)

--     local image_icon = UIUtils.GetImage(obj, "GrpItem/Img_Item")
--     local image_bg = UIUtils.GetImage(obj, "GrpBg/Img_Bg")
--     image_icon.sprite = sprite;
--     image_bg.sprite  = bg_sprite
-- end

function  UIStoreExchangePriceChangeDialog.OnInit()
    self = UIStoreExchangePriceChangeDialog;
    self:SetData();
end

function  UIStoreExchangePriceChangeDialog.OnRelease()
    self = UIStoreExchangePriceChangeDialog
end





