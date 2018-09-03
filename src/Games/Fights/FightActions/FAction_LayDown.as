package Games.Fights.FightActions {
import Games.Fights.FightRole;

import com.MyClass.Config;
import com.MyClass.Tools.Tool_Function;

/**
 * 倒地状态
 * **/
public class FAction_LayDown extends FAction_Default{
    private var nowFlag:int=0;
    private var dicUrls:* ={};
    private var countFrame:int;
    private var countReDown:int=0;
    
    public function FAction_LayDown(fr:FightRole) {
        Role=fr;
        Name="倒地";
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
    override public function resetF():void {
        nowFlag=0;
        url=dicUrls[nowFlag];
        super.resetF();
    }

    override public function enterF():void {
        super.enterF();
        if(isEnd==false && nowFlag==1){
            countFrame--;
            if(countFrame<=0){
                nowFlag=2;
                url=dicUrls[nowFlag];
                nowIndex=0;
                onChangeRoleMcByURL();
            }
        }
    }

    override protected function onAtLastFrame():void {
        if(nowFlag==2){
            countReDown=0;
            onActEndF();
        }else if(nowFlag==1){//继续躺下
            nowIndex=0;
        }else{
            nowFlag=1;
            url=dicUrls[nowFlag];
            nowIndex=0;
            nowCountMSecond=0;
            countFrame=Config.playSpeedTrue;
            countFrame -= Tool_Function.onForceConvertType(countFrame * countReDown * 0.2);//五次倒地就完全保护
            countReDown++;
            onChangeRoleMcByURL();
        }
    }
}
}
