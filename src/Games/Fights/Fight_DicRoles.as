package Games.Fights {
import Games.Datas.Data_Scene_init;
import Games.Models.RoleModel;
import Games.Scene;

import com.MyClass.Tools.Tool_ObjUtils;

/**
 * 战斗中，保存所有玩家引用的类
 * */
public class Fight_DicRoles {
    private var nowScenc:Scene;
    public var mainRole:FightRole;
    private var dicRoles:* ={};//通过netid作为key保存的role
    
    public function Fight_DicRoles(scene:Scene) {
        nowScenc=scene;
        addRolesFromData();
    }

    /** 添加玩家角色，根据入口门数据确定初始位置 */
    public function addMainRole(role:FightRole):void{
        mainRole=role;
        dicRoles[role.baseRoleMo.NetID]=role;
        var door:int=0;
        var initData:Data_Scene_init=nowScenc.initData;
        if(initData){
            door=initData.startDoor;
        }
        //TODO 找到门数据并移动role，{"info":{"y":400,"destination":"1","x":700},"type":"门"}
        mainRole.mapRole.initF(null,{"x":0,"y":300});
        nowScenc.Map.setMainRole(mainRole.mapRole);
    }

    /** 添加敌人 */
    private function addRolesFromData():void{
        var arrERm:Array =nowScenc.initData.data.arrRoles;
        if(arrERm){
            for(var i:int=0;i<arrERm.length;i++){
                var rm:RoleModel =arrERm[i][0];
                var info:* =arrERm[i][1];
                var fr:FightRole=new FightRole(rm);
                fr.mapRole.initF(null,{"x":info["x"],"y":info["y"]});
                nowScenc.Map.addMapObjectToLayer(fr.mapRole);
                dicRoles[rm.NetID]=fr;
            }
        }
    }
    
    public function enterF():void{
        var fr:FightRole;
        for(var nid:* in dicRoles){
            fr= dicRoles[nid];
            if(fr)fr.enterF();
        }
    }
    
    public function destroyF():void{
        nowScenc=null;
        mainRole=null;
        dicRoles=Tool_ObjUtils.destroyF_One(dicRoles);
    }
}
}
