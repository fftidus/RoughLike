package Games.Map {
import com.MyClass.MySourceManager;
import com.MyClass.Tools.MyPools;

import lzm.starling.swf.display.SwfMovieClip;

public class Map_ObjectView_Grounds extends Map_ObjectView{
	public static function getOne(swf:String,url:String):Map_ObjectView_Grounds{
		var one:Map_ObjectView_Grounds =MyPools.getInstance().getFromPool(swf+":"+url);
		if(one==null){
			one=new Map_ObjectView_Grounds(swf,url);
		}
		one.initF();
		return one;
	}
	
	private var mc:*;
	private var poolName:String;
	public function Map_ObjectView_Grounds(swf:String,url:String) {
		super();
		mc=MySourceManager.getInstance().getObjFromSwf(swf,url);
		poolName=swf+":"+url;
	}

	override public function initF():void {
		if(mc){
			this.addChild(mc);
			if(mc is SwfMovieClip){
				(mc as SwfMovieClip).loop=true;
				(mc as SwfMovieClip).play();
			}
		}
	}

	override public function removeF():void {
		if(mc){
			if(mc is SwfMovieClip){
				(mc as SwfMovieClip).stop(true);
			}
			MyPools.getInstance().returnToPool(poolName,this);
		}
	}
}
}
