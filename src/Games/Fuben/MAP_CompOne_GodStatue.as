package Games.Fuben{
	import com.MyClass.MainManager;
	
	import StaticDatas.SData_EventNames;

public class MAP_CompOne_GodStatue extends MAP_CompOne{
	private var _nowflag:String="空闲";
	public function get NowFlag():String{return _nowflag;}
	public function set NowFlag(flag:String):void{
		_nowflag=flag;
		Info["flag"]=flag;
	}
	
	public function MAP_CompOne_GodStatue(info:*,_item:MAP_Item){
		super(info,_item);
		if(Info["flag"]!=null){
			NowFlag=Info["flag"];
		}
		onShowMcLabel();
	}
	
	override public function onAct_beforeMove():Boolean{
		if(NowFlag=="死"){
			return false;
		}
		MainManager.getInstence().MEM.dispatchF(SData_EventNames.Fuben_StatueAct,item);
		return true;
	}
	//-----------------
	/**
	 * 特有API
	 * */
	//------------------
	private function onShowMcLabel():void{
		var label:String;
		if(NowFlag=="死"){
			label =getValue("LabelDead");
		}else if(NowFlag=="活"){
			label =getValue("LabelAlive");
		}
		item.Mc.gotoAndStop(label);
	}
	public function onDead():void{
		NowFlag="死";
		onShowMcLabel();
	}
	
	
}
}