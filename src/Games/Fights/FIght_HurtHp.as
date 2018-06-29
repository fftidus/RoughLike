package Games.Fights {
import com.MyClass.Config;
import com.MyClass.MySourceManager;
import com.MyClass.MyView.MyMC;
import com.MyClass.MyView.MyViewNumsController;
import com.MyClass.Tools.Tool_Function;
import com.MyClass.Tools.Tool_ObjUtils;

import StaticDatas.SData_Strings;

import starling.display.Sprite;
import starling.utils.Color;

public class FIght_HurtHp extends Sprite{
	private var mcHP:MyMC;
	private var mnum:MyViewNumsController;
	private var spdy:Number;
	private var spdx:Number;
	private var ay:Number;
	public var end:Boolean=false;
	
	public function FIght_HurtHp(dic:*,role:*) {
		var mc:* =MySourceManager.getInstance().getMcFromSwf(SData_Strings.SWF_战斗界面,"mc_HurtHP");
		mcHP=new MyMC(mc);
		this.addChild(mcHP);
		mnum=new MyViewNumsController(mc,null,SData_Strings.SWF_战斗界面);
		if(role!=null){
			spdy =-Math.random() * 5 - 5;
			spdx =Math.random() * 1 + 1;
			if(role.camp==1){
				spdx=-spdx;
				mnum.getNum("num_hp").setValue("对齐","右");
			}
			ay =-spdy / (Config.playSpeedTrue * 0.5);
			this.x =role.x;
			this.y =role.Role_z - role.RoleHeight/2;
		}
		if(Tool_Function.isTypeOf(dic,Number)) {
			mnum.onShowF("num_hp",dic);
		}else{
			if(dic["闪避"]==true){
				mnum.onShowF("num_hp","闪");
				spdx=0;
			}else if(dic["回复HP"] != null){
				mnum.getNum("num_hp").setValue("颜色",Color.GREEN);
				mnum.onShowF("num_hp",dic["回复HP"]);
				spdx=0;
			}else if(dic["回复MP"] != null){
				mnum.getNum("num_hp").setValue("颜色",Color.BLUE);
				mnum.onShowF("num_hp",dic["回复MP"]);
				spdx=0;
			}
			else if(dic["暴击"]!=null){
				mnum.getNum("num_hp").setValue("颜色",Color.RED);
				mnum.onShowF("num_hp","暴"+dic["暴击"]);
			}
		}
	}
	
	public function enterF():void{
		if(mcHP.currentFrame >= mcHP.totalFrames-1){
			destroyF();
		}else{
			mcHP.enterPlayF();
			this.x += spdx;
			this.y += spdy;
			spdy+=ay;
		}
	}
	
	
	public function destroyF():void{
		end=true;
		Tool_ObjUtils.getInstance().destroyDisplayObj(this);
		mcHP=Tool_ObjUtils.getInstance().destroyF_One(mcHP);
		mnum=Tool_ObjUtils.getInstance().destroyF_One(mnum);
	}
}
}
