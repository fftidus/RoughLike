package Games.Fights{
	import com.MyClass.MySourceManager;
	import com.MyClass.MyView.MyMC;
	import com.MyClass.Tools.Tool_ObjUtils;
	
	import starling.display.Sprite;

	public class Fight_FlyObject extends Sprite{
		public var Skill:*;
		public var Role:*;
		public var Tar:*;
		public var end:Boolean=false;
		
		private var mcFly:MyMC;
		private var spdy:Number;
		
		public function Fight_FlyObject(skill:*,tar:*){
			Skill=skill;
			Role=Skill.Role;
			Tar=tar;
			var mc:* =MySourceManager.getInstance().getObjFromSwf(Skill.Fly_swf,Skill.Fly_url);
			if(mc==null){
				trace(Skill.Fly_url+"：飞行没有动画");
				endF();
				return;
			}
			if(Skill.Fly_y0 != 0){
				mc.y =Skill.Fly_y0;
			}
			mcFly=new MyMC(mc);
			mcFly.loop=true;
			this.addChild(mcFly);
			if(Role.camp == 1){
				mcFly.x =Role.Role_x + Skill.Fly_x0;
			}else{
				mc.scaleX=-1;
				mcFly.x =Role.Role_x - Skill.Fly_x0;
			}
			mcFly.y =Role.Role_z;
			spdy=(Tar.Role_z - Role.Role_z) / (Math.abs(Tar.Role_x - Role.Role_x)/Skill.Fly_spd);
			Role.mainView.addFlyObject(this);
		}
		
		public function enterF():void{
			if(end){return;}
			mcFly.enterPlayF();
			if(spdy!=0){
				mcFly.y+=spdy;
				if(spdy>0){
					if(mcFly.y >= Tar.Role_z){
						spdy=0;
						mcFly.y=Tar.Role_z;
					}
				}else{
					if(mcFly.y <= Tar.Role_z){
						spdy=0;
						mcFly.y=Tar.Role_z;
					}
				}
			}
			if(Role.camp == 1){
				mcFly.x +=Skill.Fly_spd;
				if(mcFly.x>=Tar.Role_x){
					endF();
				}
			}else{
				mcFly.x -=Skill.Fly_spd;
				if(mcFly.x<=Tar.Role_x){
					endF();
				}
			}
		}
		
		public function endF():void{
			Skill.onAtkTarF(Tar);
//			Skill.onAniEndF();
			end=true;
			destroyF();
		}
		
		public function destroyF():void{
			Tool_ObjUtils.getInstance().destroyDisplayObj(this);
			end=true;
			mcFly=Tool_ObjUtils.getInstance().destroyF_One(mcFly);
			Skill=null;
			Role=null;
			Tar=null;
		}
}
}