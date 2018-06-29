package Games.Fights
{
	import com.MyClass.MyView.MyMC;
	import com.MyClass.Tools.Tool_Function;
	
	public class Fight_Action_Stand extends Fight_ActionDefault
	{
		public function Fight_Action_Stand(r:*,info:*){
			super(r);
			Tool_Function.on修改属性ByDic(this,info);
		}
		override public function resetF():void{
			super.resetF();
			var hp:int =Role.get属性("hp");
			if(hp<=0){
				Role.onRealDeadF();
			}
		}
		override public function enterF():void{
			if(Role.roleMC){
				(Role.roleMC as MyMC).loop=true;
				Role.roleMC.enterPlayF();
			}
		}
		
	}
}