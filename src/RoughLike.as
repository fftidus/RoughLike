package
{
	import com.MyClass.Config;
	import com.MyClass.Config_FunAIR;
	import com.MyClass.MainManager;
	import com.MyClass.MySourceManager;
	import com.MyClass.MySourceManager_AIR;
import com.MyClass.Tools.MyErrorSend;
import com.MyClass.VertionVo;
	import com.MyClass.VertionVo_Air;
	import com.MyClass.MyView.ImageNum;
	import com.MyClass.MyView.LoadingView;
	import com.MyClass.Tools.AlertSmall;
	import com.MyClass.Tools.AlertWindow;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;
	
	import StaticDatas.SData_Strings;
	
	import parser.Script;
	
	[SWF(width="1136", height="640",backgroundColor="0x00")]
	public class RoughLike extends Sprite
	{
		public function RoughLike()
		{
			__MC_Logo;
			super();
			Script.init(this);
			AlertSmall.Class_AlertMc=__MC_AlerForGet;
			VertionVo.Class_VertionVo=VertionVo_Air;
			VertionVo.getInstance();
			LoadingView.ArrBack=[__Loading_Big_Back11];
			LoadingView.Need外部背景图=true;
			Config.适配方式=2;
			Config.stageW=1136;
			Config.stageH=640;
			Config.ClassFunction=new Config_FunAIR();
			Config.ClassLostContext=__Loading_TextureRecover;
			MySourceManager.ClassManager=MySourceManager_AIR;
			ImageNum.SWFDefault=SData_Strings.SWF_默认UI;
			this.addEventListener(Event.ADDED_TO_STAGE,init);
			MyErrorSend.onSendF(null);
		}
		private function uncatchErrorF(e:UncaughtErrorEvent):void{
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			MainManager.getInstence().clearF();
			AlertWindow.showSimpleF(SData_Strings.Alert_意外错误,{"title":SData_Strings.Alert_意外错误Title},Config.on重启);
			//发送
			var str:String	= (e.error as Error).getStackTrace();
			MyErrorSend.onSendF(str);
		}
		private function init(e:Event):void
		{
			this.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,uncatchErrorF);
			this.removeEventListener(Event.ADDED_TO_STAGE,init);
			Config.mStage	= stage;
			Config.initF();
			if(Config.OS.indexOf("Windows")!=-1){
				VertionVo.StaticVer =Config.版本号;
			}
			new MainClass();
		}
		
	}
}