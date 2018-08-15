package Games.Datas {
import Games.Fights.FightRole;
import Games.Models.AttackModel;
import Games.Scene;

import com.MyClass.Tools.MyPools;
import com.MyClass.Tools.Tool_Function;

/**
 * 角色被攻击的累加数据
 * */
public class Data_Hurt {
    public static function getNewOne(fr:FightRole):Data_Hurt{
        if(MyPools.getInstance().hasPool("被击数据")==false){
            MyPools.getInstance().registF("被击数据");
        }
        var one:Data_Hurt=MyPools.getInstance().getFromPool("被击数据");
        if(one==null){
            one=new Data_Hurt();
        }
        one.reset(fr);
        return one;
    }
    //=========================================================================//
    private var Role:FightRole;
    /** 当前保持站姿 **/
    public var isKeepPose:Boolean;
    /** 浮空 **/
    public var isUp:Boolean;
    /** 击飞方向剩余距离：1=上下，2=左右，3=落 **/
    public var away:* ={1:0,2:0,3:0};
    /** 浮空速度 **/
    public var spdUp:Number;
    
    public function Data_Hurt() {
    }
    public function reset(fr:FightRole):void{
        Role=fr;
        isKeepPose=true;
        isUp=false;
        away[1] =0;away[2] =0;away[3] =0;
        spdUp=0;
    }
    /** 进入挨打动作前，判断是否需要进入 **/
    public function checkNeedHurtAction():Boolean{
        if(isKeepPose==false || Role.IronCon.nowNum > 0 || spdUp > 0 || away[1]!=0 || away[2]!=0 || away[3]!=0){
            return true;
        }
        return false;
    }
    /** 被攻击，进入被击状态，叠加数据 */
    public function beHurt(data:AttackModel):void{
        if(isKeepPose==true && data.data.hit_breakStand==true){
            isKeepPose=false;
        }
        if(data.data.hit_CostIron > 0){
            Role.IronCon.costIron(data.data.hit_CostIron);
        }
        if(data.data.hit_awayDirect > 0){
            var realAway:int =data.data.hit_awayPower - Tool_Function.onForceConvertType(Role.getValue("重量") * data.data.hit_awayPower * 0.01);
            if(realAway>0) {
                realAway= Math.sqrt(2 * realAway * Scene.G_away);//转换为速度，v=√2 * L * a
                if(data.data.hit_awayDirect==1){
                    away[1] -= realAway;
                }else  if(data.data.hit_awayDirect==2){
                    away[1] += realAway;
                }else  if(data.data.hit_awayDirect==3){
                    //根据攻击方的方向修改击飞方向
                    if(data.fromRole && data.fromRole.nowDirection==1){
                        away[2] += realAway;
                    }else {
                        away[2] -= realAway;
                    }
                }else  if(data.data.hit_awayDirect==4){
                    //根据攻击方的方向修改击飞方向
                    if(data.fromRole && data.fromRole.nowDirection==1){
                        away[2] -= realAway;
                    }else {
                        away[2] += realAway;
                    }
                }else  if(data.data.hit_awayDirect==5){
                    away[3] += realAway;
                }
            }
        }
        if(data.data.hit_upPower > 0){
            var addSpd:int =data.data.hit_upPower - Tool_Function.onForceConvertType(Role.getValue("重量") * data.data.hit_upPower * 0.01);
            addSpd= Math.sqrt(2 * addSpd * Scene.G);//转换为速度，v=√2 * L * a
            if(addSpd>0) {
                isUp = true;
                spdUp+=addSpd;
            }
        }else if(isUp ==true){//浮空中，强制继续浮空
            if(spdUp > 0)spdUp+=1;
            else spdUp=1;
        }
    }
    
    public function destroyF():void{
        Role=null;
        if(MyPools.getInstance().hasPool("被击数据")==true){
            MyPools.getInstance().returnToPool("被击数据",this);
        }
    }
}
}
