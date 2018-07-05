package Games.Fights {
import Games.Fights.FightActions.FAction_Run;
import Games.Fights.FightActions.FAction_Stand;

import StaticDatas.SData_RolesInfo;

import com.MyClass.Tools.Tool_ObjUtils;

/**
 * 战斗所有动作
 * */
public class Fight_DicActions {
    private var Dic:* =Tool_ObjUtils.getNewObjectFromPool();
    
    public function Fight_DicActions(fr:FightRole) {
        Dic[SData_RolesInfo.ActionName_Stand]=new FAction_Stand(fr);
        Dic[SData_RolesInfo.ActionName_Run]=new FAction_Run(fr);
    }
    
    public function hasAction(key:String):Boolean{
        if(Dic[key]==null)return false;
        return true;
    }
    public function getActionByName(key:String):*{
        return Dic[key];
    }
    
    public function destroyF():void{
        Dic=Tool_ObjUtils.destroyF_One(Dic);
    }
}
}
