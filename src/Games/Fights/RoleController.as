package Games.Fights{
	import Games.Map.Map_Object_Roles;

/**
 * 角色控制器：操作，网络，AI
 * */
public class RoleController{
	protected var Role:Map_Object_Roles;
	
	public function RoleController(_role:Map_Object_Roles)	{
		Role=_role;
	}
	
	
	public function destroyF():void{
		Role=null;
	}
}
}