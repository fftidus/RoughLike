package Games.Fights.FightActions {
import Games.Fights.FightRole;

import StaticDatas.SData_RolesInfo;

public class FAction_Stand extends FAction_Default{
    public function FAction_Stand(role:FightRole) {
        Role=role;
        Name="站立";
        isLoopAni=true;
        isEffectBySpd=false;
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
        if(Role.controller.isdown_Left()==true){
            Role.onChangeDirect("左");
            Role.onWantChangeAction(SData_RolesInfo.ActionName_Run);
        }else if(Role.controller.isdown_Right()==true){
            Role.onChangeDirect("右");
            Role.onWantChangeAction(SData_RolesInfo.ActionName_Run);
        }else if(Role.controller.isdown_Up()==true || Role.controller.isdown_Down()==true){
            Role.onWantChangeAction(SData_RolesInfo.ActionName_Run);
        }
    }
}
}
