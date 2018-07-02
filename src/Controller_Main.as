package
{
	import com.MyClass.Config;
	import com.MyClass.MainManager;
	import com.MyClass.MyEventManagerOne;
	import com.MyClass.MyKeyboardManager;
	import com.MyClass.Tools.MyKeyboard;
	import com.MyClass.Tools.Tool_ObjUtils;
	
	import StaticDatas.SData_EventNames;
	
	import laya.utils.Handler;
	
	public class Controller_Main
	{
		private static var instance:Controller_Main;
		public static function getInstance():Controller_Main{
			if(instance==null){
				instance=new Controller_Main();
			}
			return instance;
		}
		public static function destroyF():void{
			if(instance){
				instance.destroyF();
			}
		}
		
		public var dicView:* ={};
		private var meo:MyEventManagerOne=new MyEventManagerOne();
		private var mkm:MyKeyboardManager=new  MyKeyboardManager(Config.mStage);
		public function Controller_Main()
		{
			meo.addListenerF(SData_EventNames.Title_进入,Handler.create(this,on进入F,null,false),"登录");
			meo.addListenerF(SData_EventNames.Title_离开,Handler.create(this,on离开F,null,false),"登录");
			
			meo.addListenerF(SData_EventNames.ItemShop_进入,Handler.create(this,on进入F,null,false),"商店");
			meo.addListenerF(SData_EventNames.ItemShop_离开,Handler.create(this,on离开F,null,false),"商店");
			
			meo.addListenerF(SData_EventNames.Fuben_进入,Handler.create(this,on进入F,null,false),"副本");
			meo.addListenerF(SData_EventNames.Fuben_离开,Handler.create(this,on离开F,null,false),"副本");
			
			mkm.stop冒泡(MyKeyboard.BACK);
			mkm.addFunctionListener(null,Handler.create(this,onKeyBoardF,null,false));
		}
		
		private function on进入F(tar:String,val:* =null):void{
			Config.Log("收到进入："+tar+"，参数="+val);
			if(dicView[tar]!=null){
				trace("重复的界面："+tar);
				return;
			}
			var v:*;
			switch (tar){
			}
			dicView[tar]=v;
		}
		private function on离开F(tar:String):void{
			Config.Log("收到离开："+tar);
			if(dicView[tar]!=null){
				delete dicView[tar];
			}
		}
		
		private function onKeyBoardF(key:*):void{
			if(key == MyKeyboard.BACK){
				MainManager.getInstence().MEM.dispatchF(SData_EventNames.Keyboard_Back);
			}
		}
		
		public function destroyF():void{
			instance=null;
			meo=Tool_ObjUtils.getInstance().destroyF_One(meo);
			mkm=Tool_ObjUtils.getInstance().destroyF_One(mkm);
			dicView.clear();
		}
		
	}
}