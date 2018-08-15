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

    override public function resetF():void {
        if(onCheckFallDown()==true){
            return;
        }
        Role.IronCon.onClearF();
        super.resetF();
    }

    override public function enterF():void{
        super.enterF();
        checkKeyController();
    }

    /** 检查操作 */
    override protected function checkKeyController():void{
        if(Role.controller==null){return;}
        if(checkKey_Jump()==true){
            return;
        }
        if(checkKey_NormalAttack()==true){
            return;
        }
        if(Role.controller.nowMoveAng != -1){
            Role.onWantChangeAction(SData_Strings.ActionName_Run);
            if(Role.controller.nowMoveAng > 180){
                Role.onChangeDirect("左");
            }else if(Role.controller.nowMoveAng>0 && Role.controller.nowMoveAng<180){
                Role.onChangeDirect("右");
            }
        }
    }
}
}
