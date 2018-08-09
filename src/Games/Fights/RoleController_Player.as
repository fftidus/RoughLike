package Games.Fights {
import com.MyClass.Config;

import com.MyClass.MyKeyboardManager;

public class RoleController_Player extends RoleController{
    
    public function RoleController_Player(_role:FightRole) {
        super(_role);
        if (Config.OS.indexOf( "Windows") != -1) {
            mkm = new MyKeyboardManager(Config.mStage);
        }
    }
    


}
}
