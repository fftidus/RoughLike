package Games.Fights{
import com.MyClass.MyKeyboardManager;
import com.MyClass.Tools.MyKeyboard;
import com.MyClass.Tools.Tool_ObjUtils;
import com.MyClass.Tools.Tool_PlayerController.Direct4Controller;

/**
 * 角色控制器：操作，网络，AI
 * */
public class RoleController{
	protected var Role:FightRole;
    public var mkm:MyKeyboardManager;
    /** 界面上的操作元件 */
    public var btnCon:Direct4Controller;
	
	public function RoleController(_role:FightRole)	{
		Role=_role;
        Role.controller=this;
	}
	/** 当前移动的角度 */
    public function get nowMoveAng():int{
        if(btnCon){
            return btnCon.nowAngle;
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
            if(mkm.isDown(MyKeyboard.LEFT)){ return 180;  }
            if(mkm.isDown(MyKeyboard.RIGHT)){ return 90;  }
        }
        return -1;
    }
    
	public function destroyF():void{
		Role=null;
        mkm=Tool_ObjUtils.destroyF_One(mkm);
        btnCon=Tool_ObjUtils.destroyF_One(btnCon);
	}
}
}