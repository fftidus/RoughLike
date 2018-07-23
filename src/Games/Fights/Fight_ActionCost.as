package Games.Fights {
import com.MyClass.Tools.Tool_Function;

/**
 * 动作的消耗
 * */
public class Fight_ActionCost {
    private var Role:FightRole;
    private var costValue:*;//消耗
    private var costName:*;
    private var dependValue:*;//前置
    private var dependValueNum:int;
    public function Fight_ActionCost(r:FightRole) {
        Role=r;
    }
    
    public function canUse():Boolean{
        var i:int;
        if(costValue!=null){
            if(Tool_Function.isTypeOf(costValue,Array) == false){
                if(costValue == "hp" && Tool_Function.isTypeOf(costName,String) == true){//百分比
                    if(Role.getValue("hp")/Role.getValue("hpMax") < Tool_Function.onForceConvertType((costName as String).substr(costName.length-1))){
                        return false;
                    }
                }else	if(Role.getValue(costValue) < costName){
                    return false;
                }
            }else{
                for(i=0;i<costValue.length;i++){
                    if(Role.getValue(costValue[i]) < costName[i]){	return false;	}
                }
            }
        }
        if(dependValue!=null){
            if(dependValue=="hp比例"){
                if(Role.getValue("hp")/Role.getValue("hpMax") < dependValueNum){
                    return false;
                }
            }else{
                if(Role.getValue(dependValue) < dependValueNum){
                    return false;
                }
            }
        }
        return true;
    }
    
    public function destroyF():void{
        Role=null;
    }
}
}
