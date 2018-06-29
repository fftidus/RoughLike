package Games.Fuben{
	import com.MyClass.MainManager;
	import com.MyClass.MySourceManager;
	import com.MyClass.Tools.AlertWindow;
	import com.MyClass.Tools.Tool_Function;
	
	import StaticDatas.SData_EventNames;
	import StaticDatas.SData_Strings;
	
	import laya.utils.Handler;
	
	import lzm.starling.swf.display.SwfMovieClip;
	
public class MAP_CompOne_Portal extends MAP_CompOne{
	public function MAP_CompOne_Portal(info:*,_item:MAP_Item){
		super(info,_item);
		item.Mc.loop=true;
		if(Info["flag"]!=null){
			_nowflag=Info["flag"];
		}else 	if(isDoubleDoor()==true){
			_nowflag="关";
		}else{
			_nowflag="开";
		}
		NowFlag=_nowflag;
	}
	private var _nowflag:String="关";
	public function get NowFlag():String{return _nowflag;}
	public function set NowFlag(flag:String):void{
		_nowflag=flag;
		Info["flag"]=flag;
		if(NowFlag=="开"){
			item.Mc.gotoAndPlay(getValue("LabelAct"));
		}else{
			item.Mc.gotoAndPlay(getValue("LabelClose"));
		}
	}
	/** 站立后触发，只有单向传送门使用该才做 */
	override public function onAct_standOn():Boolean{
		if(isDoubleDoor()==true){return false;}
		if(NowFlag=="关"){
//			NowFlag="开";
//			item.Mc.gotoAndPlay(getValue("LabelAct"));
//			MainManager.getInstence().MEM.dispatchF(SData_EventNames.Fuben_PortalAct,item);
//			return true;
			return false;
		}
		MainManager.getInstence().MEM.dispatchF(SData_EventNames.Fuben_PortalRun,item);
		return true;
	}
	/** 只有双向传送门才能可以隔一个位置操作 */
	override public function canBeControllAway():Boolean{
		if(isDoubleDoor()==false){return false;}
		return true;
	}
	override public function onControll_away():void{
		if(NowFlag=="关"){
			MainManager.getInstence().MEM.dispatchF(SData_EventNames.Fuben_PortalAct,item);
		}else{
			MainManager.getInstence().MEM.dispatchF(SData_EventNames.Fuben_PortalRun,item);
		}
	}
	/** 是否是双向门 */
	public function isDoubleDoor():Boolean{
		var loc:String =getValue("Location");
		var info:* =item.map.data["组件"][loc];
		if(info){
			var zname:String =info["Name"];
			if(zname=="Map_ItemComp_portal" ){
				return true;
			}
		}
		return false;
	}
	public function isTarDoorAct():Boolean{
		//判断是否是关联传送门
		var loc:String =getValue("Location");
		var info:* =item.map.data["组件"][loc];
		if(info){
			var zname:String =info["Name"];
			if(zname=="Map_ItemComp_portal" && info["flag"]!="开"){
				return false;
			}
		}
		return true;
	}
	//-----------------
	/**
	 * 传送门特有API
	 * */
	//------------------
	public function onAnimateF(fend:*):void{
		//判断是否是关联传送门
		if(isTarDoorAct()==false){
			Tool_Function.onRunFunction(fend,false);
			AlertWindow.showF(SData_Strings.Alert_传送门需激活关联,null);
			return;
		}
		//开始播放动画
		var InfoAni:* =getValue("InfoAni");
		if(InfoAni==null || InfoAni["url"]==null || item.map==null){
			Tool_Function.onRunFunction(fend,true);
			return;
		}
		var swf:String =item.Mc.swfName;
		if(InfoAni && InfoAni["swf"]!=null && InfoAni["swf"] != ""){
			swf =InfoAni["swf"];
		}
		var url:String =InfoAni["url"];
		var mc:SwfMovieClip=MySourceManager.getInstance().getMcFromSwf(swf,url);
		if(mc==null){
			Tool_Function.onRunFunction(fend,true);
			return;
		}
		var typeIndex:String = InfoAni["层级"];
		Fun=fend;
		onAddAnimateToMapF(mc,typeIndex,Handler.create(this,onAniend));
	}
	private var Fun:*;
	private function onAniend():void{
		Tool_Function.onRunFunction(Fun,true);
		Fun=null;
	}
	
	
	
}
}