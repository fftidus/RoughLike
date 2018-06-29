package Games.Fights
{
	import StaticDatas.SData_Strings;

	public class Fight_ActionDefault
	{
		public var Role:Fight_Role;
		public var Name:String;
		public var swf:String;
		public var url:String;
		public var Arr_step:Array;
		public var is无敌:Boolean=false;
		public var is霸体:Boolean=false;
		
		public function Fight_ActionDefault(r:*)	{
			Role=r;
		}
		public function checkActiveF():Boolean{
			return true;
		}
		public function resetF():void{
			if(url==null){return;}
			onChangeRoleMcByURL();
		}
		public function onChangeRoleMcByURL():void{
			if(Role.get属性("spine",false)!=null){
				Role.onChangeroleMC_Spine(url);
			}else{
				if(swf==null){swf=SData_Strings.SWF_战斗界面;}
				Role.onChangeroleMC(swf,url);
			}
		}
		
		public function enterF():void{
		}
		
		public function canDead():Boolean{
			return true;
		}
		
		public function breakF():void{
		}
		
		public function get介绍():String{
			return "";
		}
		
		public function destroyF():void{
			Role=null;
		}
	}
}