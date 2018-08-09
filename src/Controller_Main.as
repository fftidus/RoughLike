package
{
	import com.MyClass.Config;
	import com.MyClass.MainManager;
	import com.MyClass.MyEventManagerOne;
	import com.MyClass.MyKeyboardManager;
	import com.MyClass.MyView.LayerStarlingManager;
	import com.MyClass.Tools.MyKeyboard;
	import com.MyClass.Tools.Tool_ObjUtils;
	
	import StaticDatas.SData_EventNames;
	
	import laya.utils.Handler;
	
	import starling.display.Sprite;
	
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
		
		private var nowMainView:Sprite;
		private var nowWindow:Sprite;
		private var arrWaiteWin:Array=[];
		private var mkm:MyKeyboardManager=new  MyKeyboardManager(Config.mStage);
		public function Controller_Main()
		{
			mkm.stopEventMop(MyKeyboard.BACK);
			mkm.addFunctionListener(null,Handler.create(this,onKeyBoardF,null,false));
			MainManager.getInstence().addEnterFrameFun(Handler.create(this,enterF,null,false));
		}
		private function enterF():void{
			if(nowWindow && nowWindow.parent==null){
				nowWindow=null;
			}else 	if(nowWindow==null && arrWaiteWin.length>0){
				var arr:Array =arrWaiteWin.shift();
				var v:Sprite=showOneWindow(arr[0],arr[1]);
				if(v){
					LayerStarlingManager.instance.LayerTop.addChild(v);
					nowWindow=v;
				}
			}
		}
		/**
		 * 添加主界面界面
		 * */
		public function addMainView(type:String,value:* =null):void{
			if(nowMainView!=null){
				nowMainView=Tool_ObjUtils.destroyF_One(nowMainView);
			}
			switch(type){
			}
		}
		/**
		 * 关闭主界面
		 * */
		public function onRemoveViewF(tar:String):void{
			nowMainView=Tool_ObjUtils.destroyF_One(nowMainView);
		}
		/**
		 * 添加一个弹窗，上一个弹窗未被移除则加入缓存中
		 * @param type 类型
		 * @param value 参数
		 * @param force 强制显示
		 * */
		public function addWindow(type:String,value:* = null,	force:Boolean=false):void{
			var v:Sprite;
			if(force==true){
				v =showOneWindow(type,value);
				if(v){
					LayerStarlingManager.instance.LayerTop.addChild(v);
				}
				return;
			}
			if(nowWindow){
				arrWaiteWin.push([type,value]);
				return;
			}
			v =showOneWindow(type,value);
			if(v){
				LayerStarlingManager.instance.LayerTop.addChild(v);
				nowWindow=v;
			}
		}
		private function showOneWindow(type:String,value:*):Sprite{
			return null;
		}
		
		
		
		private function onKeyBoardF(key:*):void{
			if(key == MyKeyboard.BACK){
				MainManager.getInstence().MEM.dispatchF(SData_EventNames.Keyboard_Back);
			}
		}
		
		public function destroyF():void{
			instance=null;
			nowMainView=Tool_ObjUtils.getInstance().destroyF_One(nowMainView);
			nowWindow=Tool_ObjUtils.destroyF_One(nowWindow);
		}
		
	}
}