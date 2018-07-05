package Games.Fights{
import com.MyClass.MyKeyboardManager;
import com.MyClass.Tools.MyKeyboard;
import com.MyClass.Tools.Tool_ObjUtils;

/**
 * 角色控制器：操作，网络，AI
 * */
public class RoleController{
	protected var Role:FightRole;
    public var mkm:MyKeyboardManager;
	
	public function RoleController(_role:FightRole)	{
		Role=_role;
	}
	
	public function isdown_Left():Boolean{
		if(mkm){
			return mkm.isDown(MyKeyboard.LEFT);
		}
		return false;
	}
	public function isdown_Right():Boolean{
        if(mkm){
            return mkm.isDown(MyKeyboard.RIGHT);
        }
		return false;
	}
    public function isdown_Up():Boolean{
        if(mkm){
            return mkm.isDown(MyKeyboard.UP);
        }
        return false;
    }
    public function isdown_Down():Boolean{
        if(mkm){
            return mkm.isDown(MyKeyboard.DOWN);
        }
        return false;
    }
	
	public function destroyF():void{
		Role=null;
        mkm=Tool_ObjUtils.destroyF_One(mkm);
	}
}
}