package Games.Fuben{
	import com.MyClass.MainManager;
	import com.MyClass.Tools.AlertWindow;
	import com.MyClass.Tools.Tool_Function;
	
	import StaticDatas.SData_EventNames;
	import StaticDatas.SData_Strings;
	
	import laya.utils.Handler;

public class MAP_CompOne_Door extends MAP_CompOne{
	public function MAP_CompOne_Door(info:*,_item:MAP_Item){
		super(info,_item);
	}
	
	override public function onAct_standOn():Boolean{
		MainManager.getInstence().MEM.dispatchF(SData_EventNames.Fuben_DoorAct,item);
		return true;
	}
	
	//-----------------
	/**
	 * 特有API
	 * */
	//------------------
	private var Fun:*;
	public function onAskToLeaveF(fend:*):void{
		Fun=fend;
		var tar:int =getValue("tarArea");
		if(tar==0){
			var f:* =Handler.create(this,onWantLeave);
			AlertWindow.showF(SData_Strings.Alert_从出口回城,null,f,true,true,f,false);
		}else{
			//TODO 前往其他地图
			Tool_Function.onRunFunction(Fun,tar);
		}
	}
	private function onWantLeave(real:Boolean):void{
		if(real==false){
			Tool_Function.onRunFunction(Fun,-1);
		}else{
			var tar:int =getValue("tarArea");
			Tool_Function.onRunFunction(Fun,tar);
		}
	}
	
}
}