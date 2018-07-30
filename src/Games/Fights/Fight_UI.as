package Games.Fights {
import StaticDatas.SData_Strings;

import com.MyClass.MySourceManager;
import com.MyClass.MyView.LayerStarlingManager;
import com.MyClass.Tools.Tool_Function;
import com.MyClass.Tools.Tool_ObjUtils;
import com.MyClass.Tools.Tool_PlayerController.Direct4Controller;

import starling.display.Sprite;

public class Fight_UI {
    private var FightView:ViewClass_FightMain;
    private var sprBack:Sprite;
    /** 方向控制器 */
    public var conMove:Direct4Controller;
    
    public function Fight_UI(view:ViewClass_FightMain) {
        FightView=view;
        sprBack=MySourceManager.getInstance().getSprFromSwf(SData_Strings.SWF_FightUI,"spr_UI");
        LayerStarlingManager.instance.LayerView.addChild(sprBack);
        Tool_Function.onFitViewToScreen(sprBack);
        conMove=new Direct4Controller(sprBack.getChildByName("_方向")as Sprite);
        conMove.startDownNeedMove=true;
        
    }
    
    
    
    public function destroyF():void{
        FightView=null;
        sprBack=Tool_ObjUtils.destroyF_One(sprBack);
        conMove=Tool_ObjUtils.destroyF_One(conMove);
    }
}
}
