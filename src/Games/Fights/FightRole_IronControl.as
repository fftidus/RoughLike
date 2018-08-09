package Games.Fights {
import com.MyClass.Config;

/**
 * 硬直控制器：硬直含义=对方动作需要停顿多少毫秒
 * */
public class FightRole_IronControl {
    private var Role:FightRole;
    private var msDefault:Number =Config.frameMS;//每帧耗时，根据硬直可变化
    private var nowNum:int=0;
    
    public function FightRole_IronControl(fr:FightRole) {
        Role=fr;
//        Role.registEnterHandler("硬直",Handler.create(this,enterF,null,false));
    }
    /** 归零硬直 */
    public function onClearF():void{
        nowNum=0;
    }
    /** 修改硬直：需要减去角色的硬直抗性 */
    public function changeIron(num:int):void{
        num -=Role.valueFight.iron;
        if(num>0) {
            nowNum += num;
        }
    }
    
    /** 每帧实际消耗时间，有硬直则减去硬直额外时间 */
    public function getMsEveryFrame():Number{
        if(nowNum > 0){
            if(msDefault>=nowNum){
                nowNum=0;
                return msDefault - nowNum;
            }else{
                nowNum -=msDefault;
                return 0;
            }
        }
        return msDefault;
    }
    
    public function destroyF():void{
        Role=null;
    }
}
}
