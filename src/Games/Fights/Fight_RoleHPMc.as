package Games.Fights
{
	import com.MyClass.MySourceManager;
	import com.MyClass.MyView.MyViewTXController;
	import com.MyClass.Tools.Tool_ObjUtils;
	
	import StaticDatas.SData_Strings;
	
	import starling.display.Sprite;

	public class Fight_RoleHPMc extends Sprite
	{
		private var Role:Fight_Role;
		private var sprBack:Sprite;
		private var W0:int;
		private var imgHp:*;
		private var mt:MyViewTXController;
		
		public function Fight_RoleHPMc(role:Fight_Role)
		{
			Role=role;
			sprBack=MySourceManager.getInstance().getSprFromSwf(SData_Strings.SWF_战斗界面,"spr_HP条");
			this.addChild(sprBack);
			imgHp=sprBack.getChildByName("_mc");
			W0=imgHp.width;
			mt=new  MyViewTXController(sprBack);
			if(role.camp==1){
				mt=Tool_ObjUtils.getInstance().destroyF_One(mt);
			}else{
				mt.set文字("tx_name",Role.Name);
			}
		}
		
		public function onShowF():void{
			var per:Number =Role.get属性("hp")/ Role.get属性("hpMax");
			if(per <= 0){
				this.visible=false;
			}else{
				this.visible=true;
				imgHp.width =W0 * per;
			}
		}
		
		public function destroyF():void{
			Role=null;
			Tool_ObjUtils.getInstance().destroyDisplayObj(this);
			sprBack=Tool_ObjUtils.getInstance().destroyF_One(sprBack);
			imgHp=Tool_ObjUtils.getInstance().destroyF_One(imgHp);
			mt=Tool_ObjUtils.getInstance().destroyF_One(mt);
		}
}
}