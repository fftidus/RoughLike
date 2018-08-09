package Games.Fights{
import com.MyClass.MyKeyboardManager;
import com.MyClass.MyView.BTNControllerStarling;
import com.MyClass.MyView.MyViewBtnController;
import com.MyClass.Tools.MyKeyboard;
import com.MyClass.Tools.Tool_ObjUtils;
import com.MyClass.Tools.Tool_PlayerController.Direct4Controller;

import laya.utils.Handler;

import starling.display.Sprite;

/**
 * 角色控制器：操作，网络，AI
 * */
public class RoleController{
	protected var Role:FightRole;
    protected var mkm:MyKeyboardManager;
    /** 界面上的操作元件 */
    private var moveCon:Direct4Controller;
    private var btnCon:MyViewBtnController;
    private var dicDown:*;
	
	public function RoleController(_role:FightRole)	{
		Role=_role;
        Role.controller=this;
	}
    /** 初始化方向摇杆 */
    public function initMoveCon(spr:Sprite):void{
        moveCon=new Direct4Controller(spr);
        moveCon.startDownNeedMove=true;
        moveCon.setMKM(mkm);
    }
    /** 初始化攻击按钮，根据装备技能显示图标 */
    public function initAttackCon(spr:Sprite):void{
        btnCon=new MyViewBtnController(spr,null,Handler.create(this,onDownAttack,null,false),Handler.create(this,onUpAttack,null,false));
        dicDown={};
        //TODO 显示图标
    }
    
    private function onDownAttack(btn:String):void{
        dicDown[btn]=true;
    }
    private function onUpAttack(btn:String):void{
        dicDown[btn]=false;
    }
    
	/** 当前移动的角度 */
    public function get nowMoveAng():int{
        if(moveCon){
            if(moveCon.nowAngle != -1)return moveCon.nowAngle;
        }
		if(mkm){
			if(mkm.isDown(MyKeyboard.UP)){
				if(mkm.isDown(MyKeyboard.LEFT)){ return 360-45;  }
				if(mkm.isDown(MyKeyboard.RIGHT)){ return 45;  }
				return 0;
			}
			else  if(mkm.isDown(MyKeyboard.DOWN)){
				if(mkm.isDown(MyKeyboard.LEFT)){ return 180+45;  }
				if(mkm.isDown(MyKeyboard.RIGHT)){ return 180-45;  }
				return 180;
			}
			if(mkm.isDown(MyKeyboard.LEFT)){ return 270;  }
			if(mkm.isDown(MyKeyboard.RIGHT)){ return 90;  }
		}
        return -1;
    }
    /** 按下跳跃键 */
    public function get isDown_Jump():Boolean{
        if(mkm){
            if(mkm.isDown(MyKeyboard.C)){ return true;  }
        }
        if(btnCon){
            return dicDown["btn_c"]==true;
        }
        return false;
    }
    /** 按下普攻键 */
    public function get isDown_NorAttack():Boolean{
        if(mkm){
            if(mkm.isDown(MyKeyboard.X)){ return true;  }
        }
        if(btnCon){
            return dicDown["btn_x"]==true;
        }
        return false;
    }
    /** 按下某个技能键 */
    public function get isDown_AnySkill():int{
        if(mkm){
            for(var i:int=0;i<ArrSkillKeyboard.length;i++) {
                if (mkm.isDown(MyKeyboard[ArrSkillKeyboard[i]]) ==true) {
                    return i;
                }
            }
        }
        if(btnCon){
            for(var i:int=0;i<ArrSkillKeyboard.length;i++) {
                if(dicDown["btn_"+i]==true)return i;
            }
        }
        return -1;
    }
    public static const ArrSkillKeyboard:Array=["Z","A","S","D","F"];
    
	public function destroyF():void{
		Role=null;
        mkm=Tool_ObjUtils.destroyF_One(mkm);
        moveCon=Tool_ObjUtils.destroyF_One(moveCon);
        btnCon=Tool_ObjUtils.destroyF_One(btnCon);
	}
}
}