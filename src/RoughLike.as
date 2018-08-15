package
{
	import com.MyClass.Config;
	import com.MyClass.Config_FunAIR;
	import com.MyClass.MainManager;
	import com.MyClass.MySourceManager;
	import com.MyClass.MySourceManager_AIR;
	import com.MyClass.VertionVo;
	import com.MyClass.VertionVo_Air;
	import com.MyClass.MyView.ImageNum;
	import com.MyClass.MyView.LoadingView;
	import com.MyClass.NetTools.Net_HttpRequest;
	import com.MyClass.Tools.AlertSmall;
	import com.MyClass.Tools.AlertWindow;
	import com.MyClass.Tools.MyErrorSend;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;
	
	import StaticDatas.SData_Strings;
	
	import lzm.util.LSOManager;
	
	import parser.Script;
	
	[SWF(width="1136", height="640",backgroundColor="0x00")]
	public class RoughLike extends Sprite
	{
		public function RoughLike()
		{
			__MC_Logo;
			super();
			Script.init(this);
			AlertWindow.classOrg=__MC_Alert;
			AlertSmall.Class_AlertMc=__MC_AlerForGet;
			VertionVo.Class_VertionVo=VertionVo_Air;
			VertionVo.getInstance();
			LoadingView.ArrBack=[__Loading_Big_Back11];
			LoadingView.Need外部背景图=true;
			Config.TypeFit=2;
			Config.stageW=1136;
			Config.stageH=640;
			Config.ClassFunction=new Config_FunAIR();
			Config.ClassLostContext=__Loading_TextureRecover;
			MySourceManager.ClassManager=MySourceManager_AIR;
			ImageNum.SWFDefault=SData_Strings.SWF_DefaultUI;
			this.addEventListener(Event.ADDED_TO_STAGE,init);
		}
		private function uncatchErrorF(e:UncaughtErrorEvent):void{
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			MainManager.getInstence().clearF();
			AlertWindow.showSimpleF(SData_Strings.Alert_Error,{"title":SData_Strings.Alert_ErrorTitle},Config.onRestart);
			//发送
			var str:String	= (e.error as Error).getStackTrace();
			MyErrorSend.onSendF(str);
		}
		private function init(e:Event):void
		{
			onSendSaveErrorF(null);
			this.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,uncatchErrorF);
			this.removeEventListener(Event.ADDED_TO_STAGE,init);
			Config.mStage	= stage;
			Config.initF();
			if(Config.OS.indexOf("Windows")!=-1){
				VertionVo.StaticVer =Config.VerMain;
			}
			new MainClass();
		}
		private static function onSendSaveErrorF(str:String):void{
			var netURL:String=MyErrorSend.netURL;
			if(netURL==null){return;}
			var strOld:String=LSOManager.get("报错待上传信息");
			if(strOld==null && str==null){return;}
			if(str==null){
				str="";
			}
			if(netURL.indexOf("/SendError?")==-1){
				netURL+="/SendError?";
			}
			var data:String ="message=";
			if(strOld){
				data+=strOld+'\n--------------\n';
			}
			data+=str;
			new Net_HttpRequest(netURL,data,netSuccess,true);
			function netSuccess(data:* =null):void{
				trace("报错上传结果："+(data));
				if(netSuccess==null){//失败！
					LSOManager.put("报错待上传信息",data);
				}else{
					LSOManager.del("报错待上传信息");
				}
			}
		}
		
	}
}