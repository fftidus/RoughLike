package Games.Fights {
	import com.MyClass.Tools.Tool_Function;
	
public class Fight_Action_Hurt extends Fight_ActionDefault{
	
	public function Fight_Action_Hurt(r:*,info:*) {
		super(r);
		Tool_Function.on修改属性ByDic(this,info);
	}
	override public function resetF():void{
		super.resetF();
	}

	override public function enterF():void {
		if (Role.roleMC) {
			Role.roleMC.enterPlayF();
		}
	}
	
	override public function breakF():void{
		super.breakF();
	}
	
	
}
}
