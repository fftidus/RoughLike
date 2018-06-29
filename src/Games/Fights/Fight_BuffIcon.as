package Games.Fights
{
	import com.MyClass.MySourceManager;
	import com.MyClass.MyView.MyViewNumsController;
	import com.MyClass.Tools.Tool_ObjUtils;
	
	import StaticDatas.SData_Buff;
	import StaticDatas.SData_Strings;
	
	import starling.display.Sprite;

	public class Fight_BuffIcon extends Sprite
	{
		private var buff:*;
		private var sprBack:Sprite;
		private var icon:*;
		private var mnum:MyViewNumsController;
		
		private var x0:int;
		private var y0:int;
		
		public function Fight_BuffIcon(b:*)
		{
			buff=b;
			sprBack=MySourceManager.getInstance().getObjFromSwf(SData_Strings.SWF_战斗界面,"spr_BuffIcon");
			this.addChild(sprBack);
			icon=MySourceManager.getInstance().getObjFromSwf(SData_Strings.SWF_战斗界面,b.URL_Icon);
			if(icon){
				sprBack.addChildAt(icon,0);
			}
			mnum=new  MyViewNumsController(sprBack,null,SData_Strings.SWF_战斗界面);
		}
		
		public function onShowF():void{
			if(buff.TypeLast==SData_Buff.TypeLast_rounds || buff.TypeLast==SData_Buff.TypeLast_delay){
				mnum.onShowF("num_持续",buff.lastRounds);
			}
		}
		
		public function setXY(_x:int,_y:int):void{
			if(this.parent==null){
				buff.Role.mainView.addLightMc(this);
			}
			x0=_x;
			y0=_y;
			enterF();
		}
		public function enterF():void{
			this.x =buff.Role.Role_x + x0;
			this.y =buff.Role.Role_z + y0;
		}
		
		
		public function destroyF():void{
			Tool_ObjUtils.getInstance().destroyDisplayObj(this);
			sprBack=Tool_ObjUtils.getInstance().destroyF_One(sprBack);
			icon=Tool_ObjUtils.getInstance().destroyF_One(icon);
			mnum=Tool_ObjUtils.getInstance().destroyF_One(mnum);
		}
	}
}