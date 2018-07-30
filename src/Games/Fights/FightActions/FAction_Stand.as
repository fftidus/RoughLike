package Games.Fights.FightActions {
import Games.Fights.FightRole;

import StaticDatas.SData_Strings;

public class FAction_Stand extends FAction_Default{
    public function FAction_Stand(role:FightRole) {
        Role=role;
        Name="站立";
        isLoopAni=true;
    }

    override public function checkCanStopByItem():Boolean{
        return true;
    }
    override public function enterF():void{
        super.enterF();
        checkKeyController();
    }

    /** 检查操作 */
    override protected function checkKeyController():void{
        if(Role.controller==null){return;}
        if(Role.controller.nowMoveAng != -1){
            Role.onWantChangeAction(SData_Strings.ActionName_Run);
            if(Role.controller.nowMoveAng > 180){
                Role.onChangeDirect("左");
            }else{
                Role.onChangeDirect("右");
            }
        }
    }
}
}
