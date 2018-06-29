package Games.Fuben{
	import com.MyClass.MainManager;
	import com.MyClass.MySourceManager;
	import com.MyClass.MyView.MyViewNumsController;
	import com.MyClass.MyView.TmpMovieClip;
	import com.MyClass.Tools.Tool_ObjUtils;
	
	import StaticDatas.SData_EventNames;
	import StaticDatas.SData_Strings;
	
	import laya.utils.Handler;
	
	import lzm.starling.swf.display.SwfMovieClip;
	
public class MAP_CompOne_Trap extends MAP_CompOne{
	
	private var _nowflag:String="空闲";
	public function get NowFlag():String{return _nowflag;}
	public function set NowFlag(flag:String):void{
		_nowflag=flag;
		Info["flag"]=flag;
	}
	
	public function MAP_CompOne_Trap(info:*,_item:MAP_Item){
		super(info,_item);
		if(Info["flag"]!=null){
			_nowflag=Info["flag"];
		}
		onShowMcLabel();
	}
	
	override public function onAct_standOn():Boolean{
		if(NowFlag.indexOf("完毕")!=-1){	return false;	}
		MainManager.getInstence().MEM.dispatchF(SData_EventNames.Fuben_TrapAct,item);
		return true;
	}
	override public function canBeControllAway():Boolean{
		if(NowFlag=="空闲")return true;
		return false;
	}
	override public function onControll_away():void{
		if(NowFlag!="空闲"){	return;	}
		MainManager.getInstence().MEM.dispatchF(SData_EventNames.Fuben_TrapBreak,item);
	}
	//-----------------
	/**
	 * 特有API
	 * */
	//------------------
	private function onShowMcLabel():void{
		var label:String;
		if(NowFlag=="空闲"){
			label =(getValue("LabelIdel"));
		}else if(NowFlag=="触发完毕"){
			label =(getValue("LabelHurtEnd"));
		}else if(NowFlag=="解除完毕"){
			label =(getValue("LabelBreakEnd"));
		}
		item.Mc.gotoAndStop(label);
	}
	public function onBreakF():void{
		NowFlag="解除完毕";
		(item.Mc as SwfMovieClip).loop=false;
		(item.Mc as SwfMovieClip).completeFunction =Handler.create(this,onBreakEnd);
		item.Mc.gotoAndPlay(getValue("LabelBreak"));
		onAnimateF("break");
	}
	private function onBreakEnd(mc:*):void{
		onShowMcLabel();
		MainManager.getInstence().MEM.dispatchF(SData_EventNames.Fuben_TrapAnimateEnd);
	}
	private var mnum:MyViewNumsController;
	public function onHurtF(hp:int):void{
		NowFlag="触发完毕";
		(item.Mc as SwfMovieClip).loop=false;
		(item.Mc as SwfMovieClip).completeFunction =Handler.create(this,onHurtEnd);
		item.Mc.gotoAndPlay(getValue("LabelHurt"));
		var mc:SwfMovieClip =MySourceManager.getInstance().getMcFromSwf(SData_Strings.SWF_FubenView,"mc_HurtHP");
		if(mc){
			mnum=new  MyViewNumsController(mc,null,SData_Strings.SWF_FubenView);
			mnum.onShowF("num_hp","-"+hp);
			var map:MAP_Square =item.map as MAP_Square;
			var tmc:TmpMovieClip=new  TmpMovieClip(mc,Handler.create(this,onHPAniEnd));
			tmc.x =item.x + map.SquareSize/2;
			tmc.y =item.y;
			map.addMcToTop(tmc);
		}
		onAnimateF("hurt");
	}
	private function onHPAniEnd():void{
		mnum=Tool_ObjUtils.getInstance().destroyF_One(mnum);
	}
	private function onHurtEnd(mc:*):void{
		onShowMcLabel();
		MainManager.getInstence().MEM.dispatchF(SData_EventNames.Fuben_TrapAnimateEnd);
	}
	
	public function onAnimateF(type:String):void{
		var InfoAni:* =getValue("InfoAni");
		if(InfoAni==null || item.map==null){
			return;
		}
		if(type=="hurt"){
			var url:String =InfoAni["urlHurt"];
		}else{
			url =InfoAni["urlBreak"];
		}
		if(url==null){return;}
		var swf:String =item.Mc.swfName;
		if(InfoAni && InfoAni["swf"]!=null && InfoAni["swf"] != ""){
			swf =InfoAni["swf"];
		}
		var mc:SwfMovieClip=MySourceManager.getInstance().getMcFromSwf(swf,url);
		if(mc==null){
			trace("陷阱没有找到动画："+url);
			return;
		}
		onAddAnimateToMapF(mc,InfoAni["层级"],null);
	}
	
}
}