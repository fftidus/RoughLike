package Games.Fights {
import Games.Datas.Data_Scene_init;
import Games.Models.RoleModel;
import Games.Scene;

/**
 * 战斗中，保存所有玩家引用的类
 * */
public class Fight_DicRoles {
    private var nowScenc:Scene;
    public var mainRole:FightRole;
    
    public function Fight_DicRoles(scene:Scene) {
        nowScenc=scene;
    }

    /** 添加玩家角色，根据入口门数据确定初始位置 */
    public function addMainRole():void{
        var initData:Data_Scene_init=nowScenc.initData;
        if(initData && initData.mainRole){
            mainRole=initData.mainRole;
        }else{
            mainRole=new FightRole(new RoleModel());
            mainRole.controller=new RoleController_Player(mainRole);
        }
        var door:int=0;
        if(initData){
            door=initData.startDoor;
        }
        //TODO 找到门数据并移动role
        mainRole.mapRole.initF(null,{"x":0,"y":300});
        nowScenc.Map.setMainRole(mainRole.mapRole);
    }
    
    public function enterF():void{
        mainRole.enterF();
    }
    
    public function destroyF():void{
        nowScenc=null;
        mainRole=null;
    }
}
}
