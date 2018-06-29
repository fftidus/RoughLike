package Games.Fuben{
	import com.MyClass.MySourceManager;
	import com.MyClass.Tools.Tool_ObjUtils;
	
	import lzm.starling.swf.display.SwfMovieClip;
	
	import starling.display.Sprite;

public class MAP_Item extends Sprite	{
	private static var poolMain:Array=[];
	private static var pool:* ={};//物品mc的缓存
	public static var MaxPool:int =30;
	public static function getOne(value:*):MAP_Item{
		var one:MAP_Item;
		if(poolMain.length>0){
			one =poolMain.shift();
		}else{
			one =new  MAP_Item();
		}
		one.setInfo(value);
		return one;
	}
	public static function removeOne(one:MAP_Item):void{
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
	//===========================================
	public var Mc:*;
	public var Info:*;
	public var row:int;
	public var col:int;
	public var renderIndex:int;
	private var _comp:MAP_CompOne;
	public function get comp():MAP_CompOne	{return _comp;}
	public function set comp(value:*):void{
		_comp=Tool_ObjUtils.getInstance().destroyF_One(_comp);
		if(value!=null){
			_comp =  MAP_CompOne.getOneByInfo(value,this);
		}
	}
	public var map:MAP_Square;
	/** 物品类 */
	public function MAP_Item(){
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
		}else{
			Mc=pool[Name].shift();
		}
		this.addChild(Mc);
		if(Mc is SwfMovieClip){
			(Mc as SwfMovieClip).play();
		}
		renderIndex=1000;
	}
	
	public function getValue(key:String):*{
		if(Info==null)return null;
		return Info[key];
	}
	/** 是否是障碍物 */
	public function isBlocked():Boolean{
		if(getValue("阻挡")==true && getValue("隐藏")!=true){
			return true;
		}
		return false;
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
		comp=null;
		map=null;
	}
	public function destroyF():void{
		Tool_ObjUtils.getInstance().destroyDisplayObj(this);
		Mc=Tool_ObjUtils.getInstance().destroyF_One(Mc);
		Info=null;
		map=null;
	}
}
}