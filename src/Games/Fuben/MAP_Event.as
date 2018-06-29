package Games.Fuben
{
	import com.MyClass.Tools.Tool_ObjUtils;
	
	import starling.display.Sprite;

	public class MAP_Event extends Sprite
	{
		public static function getOneByInfo(_info:*):MAP_Event{
			if(_info["默认数据"] && _info["默认数据"]["Name"]=="怪物点"){
				var eone:MAP_EventEnemy=new  MAP_EventEnemy();
				eone.setInfo(_info);
				return eone;
			}
			var one:MAP_Event=new  MAP_Event();
			one.setInfo(_info);
			return one;
		}
		public var map:MAP_Square;
		public var Mc:*;
		public var Info:*;
		public var row:int;
		public var col:int;
		public var renderIndex:int=1000;
		private var _Flag:String;
		public function get Flag():String{return _Flag;}
		public function set Flag(value:String):void{
			_Flag = value;
			Info["flag"]=value;
//			ViewClass_Fuben.mapData["事件"][row+":"+col]["flag"]=_Flag;
		}

		public function MAP_Event()
		{
		}
		public function setInfo(_info:*):void{//{"事件":type，"默认数据"};
			Info =_info;
			if(Info==null){	return;	}
			if(Info["flag"]!=null)_Flag=Info["flag"];
			var zname:String =Info["事件"];
		}
		public function onShowMC():void{
		}
		
		public function onVisible(real:Boolean):void{
			this.visible=real;
			if(this.visible==false){
				Mc=Tool_ObjUtils.getInstance().destroyF_One(Mc);
			}else{
				onShowMC();
			}
		}
		
		public function getValue(key:String):*{
			if(Info[key]!=null){
				return Info[key];
			}
			if(Info["默认数据"]==null){return null;}
			return Info["默认数据"][key];
		}
		
		/** 移动到该位置后判断是否触发 */
		public function onAct_standOn():Boolean{
			return false;
		}
		/** 移动到该位置周围4格后判断是否触发 */
		public function onAct_near():Boolean{
			return false;
		}
		
		public function destroyF():void{
			Tool_ObjUtils.getInstance().destroyDisplayObj(this);
			Mc=Tool_ObjUtils.getInstance().destroyF_One(Mc);
			Info=null;
			map=null;
		}
	}
}