package Games {
import Games.Datas.Data_Sound;

import StaticDatas.SData_EventNames;

import com.MyClass.Config;

import com.MyClass.MyEventManagerOne;
import com.MyClass.SoundManagerMy;
import com.MyClass.Tools.Tool_ArrayUtils;
import com.MyClass.Tools.Tool_Function;
import com.MyClass.Tools.Tool_ObjUtils;

import laya.utils.Handler;

/**
 * 场景的音效管理
 * */
public class Scene_Sounds {
    private var S:Scene;
    private var meo:MyEventManagerOne=new MyEventManagerOne();
    private var dicWaite:* ={};
    private var maxNumPerFrame:int=1;
    private var maxNumWaite:int;
    public function Scene_Sounds(s:Scene) {
        S=s;
        maxNumWaite= maxNumPerFrame * Config.playSpeedTrue / 10;
        meo.addListenerF(SData_EventNames.Scene_Sound,Handler.create(this,onWantPlaySound,null,false));
    }
    
    public function enterF():void{
        for(var key:String in dicWaite){
            var i:int=0;
            while(i++<maxNumPerFrame && dicWaite[key].length > 0) {
                var data:Data_Sound = dicWaite[key].shift();
                var vol:Number =1;
                if(S && S.DicRoles && S.DicRoles.mainRole){
                    var L:int =Tool_Function.onGetLengthBetweenPoint(data,S.DicRoles.mainRole);
                    if(L > Config.stageH){
                        vol -=(L - Config.stageH)/Config.stageH;
                    }
                }
                if(vol > 0) {
                    SoundManagerMy.getInstance().playSound(key, vol);
                }
                data.destroyF();
            }
            if(dicWaite[key].length == 0){
                dicWaite[key]=Tool_ObjUtils.destroyF_One(dicWaite[key]);
                delete dicWaite[key];
            }
        }
    }
    
    private function onWantPlaySound(data:Data_Sound):void{
        if(data==null)return;
        if(dicWaite[data.Name]==null){
            dicWaite[data.Name]=Tool_ArrayUtils.getNewArrayFromPool();
        }
        dicWaite[data.Name].push(data);
        if(dicWaite[data.Name].length > maxNumWaite){
            data =dicWaite[data.Name].shift();
            data.destroyF();
        }
    }
    
    public function destroyF():void{
        S=null;
        meo=Tool_ObjUtils.destroyF_One(meo);
        dicWaite=Tool_ObjUtils.destroyF_One(dicWaite);
    }
}
}
