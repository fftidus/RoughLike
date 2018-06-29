package Games.Fuben{
	import com.MyClass.MainManager;
	import com.MyClass.MySourceManager;
	import com.MyClass.MyView.TmpMovieClip;
	import com.MyClass.Tools.AlertWindow;
	
	import Games.Models.GameObjectModel;
	
	import StaticDatas.SData_EventNames;
	import StaticDatas.SData_Strings;
	
	import laya.utils.Handler;
	
	import lzm.starling.swf.display.SwfMovieClip;

public class MAP_CompOne_Box extends MAP_CompOne	{
	public function MAP_CompOne_Box(info:*,_item:MAP_Item)		{
		super(info,_item);
		if(Info["flag"]!=null){
			NowFlag=Info["flag"];
			if(NowFlag=="开"){
				item.Mc.gotoAndStop(getValue("LabelOpened"));
			}else{
				item.Mc.gotoAndStop(getValue("LabelClose"));
			}
		}else{
			item.Mc.gotoAndStop(getValue("LabelClose"));
		}
	}
	
	private var _nowflag:String="关";
	public function get NowFlag():String{return _nowflag;}
	public function set NowFlag(flag:String):void{
		_nowflag=flag;
		Info["flag"]=flag;
	}
	
	override public function onAct_beforeMove():Boolean{
		return false;
//		if(NowFlag=="开"){
//			return false;
//		}
//		MainManager.getInstence().MEM.dispatchF(SData_EventNames.Fuben_OpenBox,item);
//		return true;
	}
	override public function canBeControllAway():Boolean{
		if(NowFlag=="关")return true;
		return false;
	}
	override public function onControll_away():void{
		if(NowFlag!="关"){	return;	}
		MainManager.getInstence().MEM.dispatchF(SData_EventNames.Fuben_OpenBox,item);
	}
	//-----------------
	/**
	 * 宝箱特有API
	 * */
	//------------------
	public function onOpenF(arr:Array):void{
		Arr_waiteGift=arr;
		for(var i:int=0;i<Arr_waiteGift.length;i++){
			Arr_waiteGift[i]=new GameObjectModel(Arr_waiteGift[i]);
		}
		(item.Mc as SwfMovieClip).completeFunction =Handler.create(this,onShowGift);
		item.Mc.gotoAndPlay(getValue("LabelOpening"));
		onAnimateF();
	}
	private var Arr_waiteGift:Array;
	private function onShowGift(mc:*):void{
		if(item==null){return;}
		(item.Mc as SwfMovieClip).completeFunction=null;
		NowFlag="开";
		item.Mc.gotoAndStop(getValue("LabelOpened"));
		var str:String=SData_Strings.getStringByGiftArray(Arr_waiteGift);
		AlertWindow.showF("获得物品：\n"+str,null,Handler.create(this,onOpenEndF));
	}
	private function onOpenEndF():void{
		MainManager.getInstence().MEM.dispatchF(SData_EventNames.Fuben_OpenBoxEnd);
	}
	
	public function onAnimateF():void{
		var InfoAni:* =getValue("InfoAni");
		if(InfoAni==null || InfoAni["url"]==null || item.map==null){
			return;
		}
		var swf:String =item.Mc.swfName;
		if(InfoAni && InfoAni["swf"]!=null && InfoAni["swf"] != ""){
			swf =InfoAni["swf"];
		}
		var url:String =InfoAni["url"];
		var mc:SwfMovieClip=MySourceManager.getInstance().getMcFromSwf(swf,url);
		if(mc==null){
			return;
		}
		var tmc:TmpMovieClip=new  TmpMovieClip(mc);
		tmc.x =item.x;
		tmc.y =item.y;
		//"层级":"当前层最上"，"最上"
		var typeIndex:String = InfoAni["层级"];
		onAddAnimateToMapF(mc,typeIndex,null);
	}
	
}
}