package Games.Fuben{
	import com.MyClass.Tools.Tool_Function;
	
	import laya.utils.Handler;
	
	import lzm.starling.swf.display.SwfMovieClip;

public class MAP_CompOne{
	public static function getOneByInfo(info:*, item:MAP_Item):MAP_CompOne{
		//info = {"Name"：fileName， "默认数据"：{}，	"Hide":……}
		if(info["默认数据"] &&  info["默认数据"]["Name"]=="宝箱"){
			return new MAP_CompOne_Box(info,item);
		}
		if(info["默认数据"] &&  info["默认数据"]["Name"]=="传送门"){
			return new MAP_CompOne_Portal(info,item);
		}
		if(info["默认数据"] &&  info["默认数据"]["Name"]=="陷阱"){
			return new MAP_CompOne_Trap(info,item);
		}
		if(info["默认数据"] &&  info["默认数据"]["Name"]=="神像"){
			return new MAP_CompOne_GodStatue(info,item);
		}
		if(info["默认数据"] &&  info["默认数据"]["Name"]=="出口"){
			return new MAP_CompOne_Door(info,item);
		}
		return new MAP_CompOne(info,item);
	}
	
	
	public var Name:String;
	public var item:MAP_Item;
	public var Info:*;
	/** 地图组件 */
	public function MAP_CompOne(info:*,_item:MAP_Item)	{
		Info=info;
		if(info["默认数据"]){
			Name =Info["默认数据"]["Name"];
		}
		item=_item;
	}
	
	public function getValue(key:String):*{
		if(Info[key]==null && Info["默认数据"]!=null){
			return Info["默认数据"][key];
		}
		return Info[key];
	}
	/** 在移动到这个组件位置前，判断是否触发组件，返回是否阻挡 */
	public function onAct_beforeMove():Boolean{
		return false;
	}
	/** 移动到该位置后判断是否触发 */
	public function onAct_standOn():Boolean{
		return false;
	}
	/** 提前判断能否被隔壁位置操作 */
	public function canBeControllAway():Boolean{
		return false;
	}
	/** 从隔壁点击触发 */
	public function onControll_away():void{
	}
	/** 组件触发动画 */
	public function onAddAnimateToMapF(mc:SwfMovieClip,typeIndex:String,fend:*):void{
		FunAniEnd=fend;
		if(mc==null){
			onCompAniEnd();
			return;
		}
		var tmc:MAP_TmpMovieclip=new  MAP_TmpMovieclip(mc,Handler.create(this,onCompAniEnd));
		tmc.row =item.row;
		tmc.colum=item.col;
		tmc.x =item.x;
		tmc.y =item.y;
		//"层级":"当前层最上"，"最上"
		var map:MAP_Square =item.map as MAP_Square;
		if(typeIndex.indexOf("当前")==0){//遮挡当前层和上层，但会被下层遮挡
			tmc.renderIndex++;
			map.addMcToLayerUp(tmc);
		}else if(typeIndex.indexOf("最上")==0){
			map.addMcToTop(tmc);
		}
	}
	private var FunAniEnd:*;	
	private function onCompAniEnd():void{
		Tool_Function.onRunFunction(FunAniEnd);
		FunAniEnd=null;
	}
	
	public function destroyF():void{
		item=null;
	}
}
}