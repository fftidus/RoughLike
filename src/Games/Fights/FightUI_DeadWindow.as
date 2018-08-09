package Games.Fights {
import com.MyClass.MainManagerOne;
import com.MyClass.Tools.AlertWindow;
import com.MyClass.Tools.Tool_ObjUtils;

import laya.utils.Handler;

import starling.display.Sprite;
import starling.filters.FragmentFilter;

/**
 * 死亡弹窗
 * */
public class FightUI_DeadWindow extends Sprite{
    private var View:ViewClass_FightMain;
    private var fil:FragmentFilter;
    private var per:int=255;
    private var mmo:MainManagerOne=new  MainManagerOne();
    
    public function FightUI_DeadWindow(v:ViewClass_FightMain) {
        View=v;
        View.addChild(this);
        fil=Tool_ObjUtils.getInstance().add颜色滤镜(View.scene,Tool_ObjUtils.getInstance().Color滤镜Type_灰度,per);
        mmo.addEnterFrameFun(Handler.create(this,enterF,null,false));
    }

    private function enterF():void{
        if(per<=1){
            mmo=Tool_ObjUtils.getInstance().destroyF_One(mmo);
            AlertWindow.showF("角色死亡！",null,Handler.create(this,initF));
            return;
        }
        per -=5;
        fil=Tool_ObjUtils.getInstance().add颜色滤镜(View.scene,Tool_ObjUtils.getInstance().Color滤镜Type_灰度,per);
    }

    private function initF():void{
//        View.onReStartF();
        destroyF();
    }

    public function destroyF():void{
        View=null;
        mmo=Tool_ObjUtils.getInstance().destroyF_One(mmo);
        Tool_ObjUtils.getInstance().destroyDisplayObj(this);
    }
}
}
