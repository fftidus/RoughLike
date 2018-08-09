package Games.Fights.FightActions {
import Games.Fights.FightRole;

import com.MyClass.Config;

public class FAction_RunStop extends FAction_Default{
    private var spdMove:Number;
    private var dicL:*;
    public function FAction_RunStop(fr:FightRole) {
        Role=fr;
        Name="急停";
        Role=fr;
    }

    override public function resetF():void {
        super.resetF();
        var spd:Number =Role.getValue("移速");
        spdMove= spd / Config.playSpeedTrue;
        if(spdMove<=0)return;
        if(dicL==null && Role.mapRole.Role && Role.mapRole.Role.totalFrames-2 > 0){
            dicL={};
            var a:Number= - spdMove / Role.mapRole.Role.totalFrames-2;
            for(var i:int=0;i<Role.mapRole.Role.totalFrames-2;i++){
                dicL[i]=spdMove+a;
            }
        }
    }

    override protected function onDoFrameEvent():void {
        if(dicL && dicL[nowIndex]){
            if(Role.nowDirection==0) {
                Role.onWantMoveX(dicL[nowIndex]);
            }else if(Role.nowDirection==1){
                Role.onWantMoveX(-dicL[nowIndex]);
            }
            onCheckFallDown();
        }
        
    }
}
}
