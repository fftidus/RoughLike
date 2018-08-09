package Games.Models.PackageModel {
import com.MyClass.MySourceManager;
import com.MyClass.Tools.Tool_ObjUtils;

import lzm.starling.swf.display.SwfSprite;

import starling.display.Sprite;

public class PackageModel_View_Page{

    private var sprBack:Sprite;

    public function PackageModel_View_Page(spr:Sprite) {
        this.sprBack = spr;

        if(sprBack is SwfSprite && sprBack.numChildren > 1){

        }
        else{
//            sprBack=MySourceManager.getInstance().getSprFromSwf(swf,"spr_背包");
//            sprBack.x =spr.x;
//            sprBack.y =spr.y;
//            sprBack.scaleX=spr.scaleX;
//            sprBack.scaleY=spr.scaleY;
//            sprBack.name =spr.name;
//            spr.parent.addChildAt(sprBack,spr.parent.getChildIndex(spr));
//            Tool_ObjUtils.getInstance().destroyF_One(spr);
        }
    }

    public function netChangeF(dic:*):void {

    }

    public function netUpdateF():void{

    }

    public function destroyF():void{
        this.sprBack = Tool_ObjUtils.destroyF_One(sprBack);
    }
}
}
