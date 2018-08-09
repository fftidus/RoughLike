package Games.Fights {
import StaticDatas.SData_Strings;

import com.MyClass.MySourceManager;
import com.MyClass.MyView.LayerStarlingManager;
import com.MyClass.Tools.Tool_Function;
import com.MyClass.Tools.Tool_ObjUtils;

import starling.display.Sprite;

public class Fight_UI {
    private var FightView:ViewClass_FightMain;
    private var sprBack:Sprite;
    public function Fight_UI(view:ViewClass_FightMain) {
        FightView=view;
        sprBack=MySourceManager.getInstance().getSprFromSwf(SData_Strings.SWF_FightUI,"spr_UI");
        LayerStarlingManager.instance.LayerView.addChild(sprBack);
        Tool_Function.onFitViewToScreen(sprBack);
    }
    
    public function getSpr_MoveCon():Sprite{
        return sprBack.getChildByName("_方向")as Sprite;
    }
    public function getSpr_AttackCon():Sprite{
        return sprBack.getChildByName("_攻击")as Sprite;
    }
    
    
    public function destroyF():void{
        FightView=null;
        sprBack=Tool_ObjUtils.destroyF_One(sprBack);
    }
}
}
