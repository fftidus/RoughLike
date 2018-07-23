package Games.Map {
import com.MyClass.Config;
import com.MyClass.MySourceManager;
import com.MyClass.Tools.MyPools;
import com.MyClass.Tools.Tool_ObjUtils;

import Games.Controller_Scene;

import lzm.starling.swf.display.SwfMovieClip;

import starling.display.Sprite;

/**
 * 地图物体的显示元件
 * */
public class Map_ObjectView extends Sprite{
	/** 获得基础的显示元件 */
    public static function getOne(swf:String,url:String):Map_ObjectView{
        var pool:MyPools;
        var one:Map_ObjectView;
        if(Controller_Scene.getInstance().nowScene){
            pool=Controller_Scene.getInstance().nowScene.pool;
            one=pool.getFromPool(swf+":"+url);
        }
        if(one==null){
            one=new Map_ObjectView();
        }
        one.initBaseMc(swf,url);
        return one;
    }
	//====================================================
    protected var mc:*;
    protected var poolName:String;
    public function Map_ObjectView() {
	}
	
	public function initBaseMc(swf:String,url:String):void{
		if(swf!=null){
            mc=MySourceManager.getInstance().getObjFromSwf(swf,url);
            if(mc==null){Config.Log(swf+"："+url+"，找不到地面图")}
            else{
                this.addChild(mc);
            }
            poolName=swf+":"+url;
        }
        if(mc && mc is SwfMovieClip){
            (mc as SwfMovieClip).play(true);
        }
	}
	
	public function get currentFrame():int{
		if(mc && mc is SwfMovieClip){
			return (mc as SwfMovieClip).currentFrame;
		}
		return 0;
	}
	public function get totalFrames():int{
		if(mc && mc is SwfMovieClip){
			return (mc as SwfMovieClip).totalFrames;
		}
		return 0;
	}
	
	
	public function removeF():void{
        if(mc){
            if(mc is SwfMovieClip){
                (mc as SwfMovieClip).stop(true);
            }
        }
        if(Controller_Scene.getInstance().nowScene){
            Controller_Scene.getInstance().nowScene.pool.returnToPool(poolName,this);
        }
	}
	public function destroyF():void{
		Tool_ObjUtils.destroyDisplayObj(this);
		mc=Tool_ObjUtils.destroyF_One(mc);
	}
}
}
