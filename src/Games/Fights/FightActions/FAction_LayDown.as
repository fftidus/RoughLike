package Games.Fights.FightActions {
import Games.Fights.FightRole;

/**
 * 倒地状态
 * **/
public class FAction_LayDown extends FAction_Default{
    private var nowFlag:int=0;
    private var dicUrls:* ={};
    
    public function FAction_LayDown(fr:FightRole) {
        Role=fr;
        Name="倒地";
        isLoopAni=true;
    }
    override public function initF(info:*):void {
        super.initF(info);
        if(info){
            //暂时只要一个正面倒地效果，背面击飞后倒地强制修改朝向
            dicUrls[0]=info["url倒"];
            dicUrls[1]=info["url躺"];
            dicUrls[2]=info["url起"];
        }
    }
    
    
}
}
