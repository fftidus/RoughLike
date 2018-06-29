package Games.Fights{
	import com.MyClass.Tools.Tool_Function;
	
public class Fight_Action_Move extends Fight_ActionDefault{
	
	public var endX:int;
	public var endY:int;
	private var spdx:Number;
	private var spdy:Number;
	
	public function Fight_Action_Move(r:*,info:*){
		super(r);
		Tool_Function.on修改属性ByDic(this,info);
	}
	
	override public function resetF():void{
		super.resetF();
		if(Role.roleMC){
			Role.roleMC.loop=true;
		}
	}
	
	override public function enterF():void{
		if(Role.roleMC){
			Role.roleMC.enterPlayF();
		}
	}
	
	override public function breakF():void {
		super.breakF();
	}
	override public function destroyF():void {
		super.destroyF();
	}
}
}