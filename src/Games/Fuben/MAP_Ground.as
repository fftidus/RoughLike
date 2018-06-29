package Games.Fuben{
	import com.MyClass.MySourceManager;
	import com.MyClass.Tools.Tool_ObjUtils;
	
	import lzm.starling.swf.display.SwfMovieClip;
	
	import starling.display.Sprite;

public class MAP_Ground extends Sprite{
	private static var poolMain:Array=[];
	private static var pool:* ={};
	public static var MaxPool:int =100;
	public static function getOne(value:*):MAP_Ground{
		var one:MAP_Ground;
		if(poolMain.length>0){
			one =poolMain.shift();
		}else{
			one =new  MAP_Ground();
		}
		one.setInfo(value);
		return one;
	}
	public static function removeOne(one:MAP_Ground):void{
		if(one==null){return;}
		one.clear();
		poolMain.push(one);
	}
	//--------------------------------------------------------------
	public static function destroyF():void{
		poolMain=Tool_ObjUtils.getInstance().destroyF_One(poolMain);
		poolMain=[];
		pool=Tool_ObjUtils.getInstance().destroyF_One(pool);
		pool={};
	}
	/**********************************************************************/
	/**********************************************************************/
	/**********************************************************************/
	public var Mc:*;
	public var Info:*;
	public var row:int;
	public var col:int;
	
	public function MAP_Ground()	{
	}
	
	public function get Name():String{
		if(Info==null)return null;
		return Info["swf"]+":"+Info["url"];
	}
	
	public function setInfo(_info:*):void{
		Info =_info;
		if(Info==null){	return;	}
		if(pool[Name]==null || pool[Name].length==0){
			Mc=MySourceManager.getInstance().getObjFromSwf(Info["swf"],Info["url"]);
//			Tool_ImgUtils.on取消平滑(Mc);
		}else{
			Mc=pool[Name].shift();
		}
		this.addChild(Mc);
		if(Mc is SwfMovieClip){
			(Mc as SwfMovieClip).play();
		}
	}
	
	public function getValue(key:String):*{
		if(Info==null)return null;
		return Info[key];
	}
	
	public function clear():void{
		this.removeFromParent();
		if(Mc){
			if(Name!=null){
				if(pool[Name]==null){
					pool[Name]=[];
				}
				if(pool[Name].length < MaxPool){
					pool[Name].push(Mc);
				}
			}
			this.removeChild(Mc);
			if(Mc is SwfMovieClip){
				(Mc as SwfMovieClip).gotoAndStop(0,true);
			}
			Mc=null;
		}
		Info=null;
	}
	public function destroyF():void{
		Tool_ObjUtils.getInstance().destroyDisplayObj(this);
		Mc=Tool_ObjUtils.getInstance().destroyF_One(Mc);
		Info==null;
	}
}
}