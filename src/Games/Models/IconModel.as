package Games.Models{
import com.MyClass.MySourceManager;
import com.MyClass.MyView.MyViewNumsController;
import com.MyClass.Tools.Tool_Function;
import com.MyClass.Tools.Tool_ObjUtils;
import com.MyClass.Tools.Tool_SpriteUtils;

import StaticDatas.SData_Strings;

import starling.display.Image;
import starling.display.Sprite;

public class IconModel extends Sprite{
    public var obj:*;
    public var needShowLv:Boolean;
    public var needShowNum:Boolean;
    private var sprBack:Sprite;
    private var icon:*;
    private var imgBack:Image;//品质底
    private var swfIcon:String;
    private var mnum:MyViewNumsController;
    /** 图标类 */
    public function IconModel(_obj:*,spr:Sprite,_swfIcon:String,  needELv:Boolean=true,	needNum:Boolean=true){
        swfIcon=_swfIcon;
        needShowLv=needELv;
        needShowNum=needNum;
        if(spr){
            sprBack=spr;
        }else{
            sprBack=MySourceManager.getInstance().getSprFromSwf(SData_Strings.SWF_DefaultUI,"spr_Icon");
        }
        if(sprBack==null){
            trace(_obj,"图标没找到sprBack");
            return;
        }
        Tool_SpriteUtils.onAddchild_ChangeParent(this,sprBack);
        mnum=new  MyViewNumsController(sprBack,null,swfIcon);
        initF(_obj);
    }

    public function initF(_obj:*):void{
        obj=_obj;
        if(sprBack==null){return;}
        icon=Tool_ObjUtils.getInstance().destroyF_One(icon);
        imgBack=Tool_ObjUtils.getInstance().destroyF_One(imgBack);
        mnum.onShowF("num_数量","");
        var b:* =sprBack.getChildByName("b");
        if(obj==null){
            if(b){b.visible=true;	}
            return;
        }
        if(swfIcon){
            icon=MySourceManager.getInstance().getImgFromSwf(swfIcon,obj.getURL());
        }
        if(Tool_Function.isTypeOf(obj,WeaponModel)){
            if(icon==null)icon=MySourceManager.getInstance().getImgFromSwf(SData_Strings.SWF_IconWea,obj.getURL());
            imgBack=MySourceManager.getInstance().getImgFromSwf(SData_Strings.SWF_DefaultUI,"img_品级框"+obj.rank);
            if(needShowLv){
                mnum.onShowF("num_数量","Lv"+obj.lv);
            }
        }else 	if(Tool_Function.isTypeOf(obj,ArmorModel)){
            if(icon==null)icon=MySourceManager.getInstance().getImgFromSwf(SData_Strings.SWF_IconArm,obj.getURL());
            imgBack=MySourceManager.getInstance().getImgFromSwf(SData_Strings.SWF_DefaultUI,"img_品级框"+obj.rank);
            if(needShowLv){
                mnum.onShowF("num_数量","Lv"+obj.lv);
            }
        }else 	if(Tool_Function.isTypeOf(obj,ItemModel)){
            if(icon==null)icon=MySourceManager.getInstance().getImgFromSwf(SData_Strings.SWF_IconItem,obj.getURL());
            if(needShowNum){
                mnum.onShowF("num_数量",obj.Num);
            }
        }else 	if(Tool_Function.isTypeOf(obj,MaterialModel)){
            if(icon==null)icon=MySourceManager.getInstance().getImgFromSwf(SData_Strings.SWF_IconMat,obj.getURL());
            if(needShowNum){
                mnum.onShowF("num_数量",obj.Num);
            }
        }
        else if(Tool_Function.isTypeOf(obj,GameObjectModel)) {
            var go:GameObjectModel = obj;
            if (go.Type == "武器") {
                if(icon==null)icon=MySourceManager.getInstance().getImgFromSwf(SData_Strings.SWF_IconWea,obj.getURL());
                imgBack = MySourceManager.getInstance().getImgFromSwf(SData_Strings.SWF_DefaultUI, "img_品级框" + go.rank);
                if (needShowLv) {
                    mnum.onShowF("num_数量", "Lv" + obj.lv);
                }
            } else if (go.Type == "防具") {
                if(icon==null)icon=MySourceManager.getInstance().getImgFromSwf(SData_Strings.SWF_IconArm,obj.getURL());
                imgBack = MySourceManager.getInstance().getImgFromSwf(SData_Strings.SWF_DefaultUI, "img_品级框" + go.rank);
                if (needShowLv) {
                    mnum.onShowF("num_数量", "Lv" + obj.lv);
                }
            } else {
                if(go.Type=="道具") {
                    if (icon == null) icon = MySourceManager.getInstance().getImgFromSwf(SData_Strings.SWF_IconItem, obj.getURL());
                }else if(go.Type=="素材") {
                    if (icon == null) icon = MySourceManager.getInstance().getImgFromSwf(SData_Strings.SWF_IconMat, obj.getURL());
                }
                if (needShowNum && obj.Num > 0) {
                    mnum.onShowF("num_数量", obj.Num);
                }
            }
            if(icon==null)icon=MySourceManager.getInstance().getObjFromSwf(SData_Strings.SWF_DefaultUI,go.getURL());
        }
        if(icon){
            if(sprBack.numChildren<=1){
                sprBack.addChild(icon);
            }else{//至少2层：底，数字，_icon
                sprBack.addChildAt(icon,1);
            }
            if(imgBack){
                sprBack.addChildAt(imgBack,0);
                if(b){	b.visible=false;}
            }else if(b){
                b.visible=true;
            }
            var tmpicon:* =sprBack.getChildByName("_icon");
            if(tmpicon){
                icon.x =tmpicon.x;
                icon.y =tmpicon.y;
            }
        }else{
            if(b){	b.visible=true;}
        }
    }


    public function destroyF():void{
        obj=null;
        sprBack=Tool_ObjUtils.getInstance().destroyF_One(sprBack);
        icon=Tool_ObjUtils.getInstance().destroyF_One(icon);
        imgBack=Tool_ObjUtils.getInstance().destroyF_One(imgBack);
        mnum=Tool_ObjUtils.getInstance().destroyF_One(mnum);
    }
}
}