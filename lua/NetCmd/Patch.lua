require("NetCmd.NetLib")
print("start patching protocol");

--[[
--注册解包协议补丁示例
NetTool.RegistUnPackPatch("Res_roleInfo",function(cmd,msg)

    print("##### Res_roleInfo");
    CommonUnPack(cmd.cmd,msg,function(byteBuffer)
        cmd.id = byteBuffer:ReadLong();
        cmd.uid = byteBuffer:ReadInt();
        cmd.name = byteBuffer:ReadLanString();
        cmd.create_date = byteBuffer:ReadInt();
        cmd.broadcast_sign = byteBuffer:ReadLanString();
        cmd.private_sign = byteBuffer:ReadLanString();
    end);

end);
--注册打包协议补丁示例
NetTool.RegistPackPatch("Req_user_testLogin",function(cmd)
    return CommonPack(cmd.cmd,function(byteBuffer)
        byteBuffer:WriteInt(cmd.user_id);
    end);
end);


--Lua消息测试
require("NetCmd.LuaRes_roleInfo")
local function UserTestLoginNetMsgDelegate(msg)
    local role = LuaRes_roleInfo.New();
    role:UnPack(msg);
    print(role.id);
    print(role.uid)

    local data = role:Pack();
    print(type(data));
    print(string.len(data));
end
CS.NetSys.Instance:AddNetMsgListener(CS.Cmd.CmdDef.roleInfo, UserTestLoginNetMsgDelegate);
--]]
print("finish patching protocol");
