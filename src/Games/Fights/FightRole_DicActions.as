package Games.Fights {
import StaticDatas.SData_RolesInfo;

import com.MyClass.Tools.Tool_ObjUtils;

import Games.Fights.FightActions.FAction_Run;
import Games.Fights.FightActions.FAction_Stand;

import StaticDatas.SData_Strings;

/**
 * 战斗所有动作
 * */
public class FightRole_DicActions {
    private var Dic:* =Tool_ObjUtils.getNewObjectFromPool();
    
    public function FightRole_DicActions(fr:FightRole) {
        var info:* =SData_RolesInfo.getInstance().Dic[fr.baseRoleMo.baseID];
        //站立
        var stand:FAction_Stand=new FAction_Stand(fr);
        stand.initF(info[SData_Strings.ActionName_Stand]);
        Dic[SData_Strings.ActionName_Stand]=stand;
        //跑动
        var run:FAction_Run =new FAction_Run(fr);
        Dic[SData_Strings.ActionName_Run]=run;
        run.initF(info[SData_Strings.ActionName_Run]);
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
