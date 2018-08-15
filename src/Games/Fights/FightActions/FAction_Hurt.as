package Games.Fights.FightActions {
import Games.Datas.Data_AttackArea;
import Games.Fights.FightRole;
import Games.Scene;

import StaticDatas.SData_Strings;

import com.MyClass.Tools.Tool_ObjUtils;

/**
 * 被击动作，包含硬直、浮空、击飞、击退过程。不包括落地！
 * */
public class FAction_Hurt extends FAction_Default{
    
	public function FAction_Hurt(fr:FightRole) {
		Role=fr;
		Name="挨打";
		isLoopAni=false;
	}

    override public function initF(info:*):void {
        super.initF(info);
		if(hitArea==null){
			//自动生成倒地碰撞区域
			if(Role && Role.baseRoleMo && Role.baseRoleMo.hitArea){
                hitArea=new Data_AttackArea([Role.baseRoleMo.hitArea.points[3]/2	,Role.baseRoleMo.hitArea.yUp	,-Role.baseRoleMo.hitArea.points[0]*2]);
			}
		}
    }

    override public function resetF():void {
		if(Role.hurtData==null || Role.hurtData.checkNeedHurtAction()==false){
            Role.onWantChangeAction(SData_Strings.ActionName_Stand);
			return;
		}
        super.resetF();
    }


    override public function enterF():void {
        if(isEnd==true){onActEndF();return;}
        if(Role.hurtData.isUp==false){//击飞+硬直
            onGroundEnterF();
        }else{//浮空+击飞
            onSkyEnterF();
        }
        if(isEnd==false) {
            nextFrame();
        }
    }
    /** 地面：硬直+击飞 **/
    protected function onGroundEnterF():void{
        if(Role.IronCon.nowNum==0 && Role.hurtData.away[1]==0 && Role.hurtData.away[2]==0 && Role.hurtData.away[3]==0){
            onActEndF();
            return;
        }
        if(Role.IronCon.nowNum>0){
            Role.IronCon.getMsEveryFrame();
        }
        onAwayEnterF();
    }
    /** 击飞：3方向砸地不计算，分开到地面和浮空分开算 **/
    protected function onAwayEnterF():void{
        if(Role.hurtData.away[1] != 0){
            Role.onWantMoveY(Role.hurtData.away[1]);
            if(Role.hurtData.away[1] > 0){
                Role.hurtData.away[1] -= Scene.G_away;
                if(Role.hurtData.away[1] <0)Role.hurtData.away[1]=0;
            }else{
                Role.hurtData.away[1] += Scene.G_away;
                if(Role.hurtData.away[1]>0)Role.hurtData.away[1]=0;
            }
        }
        if(Role.hurtData.away[2] != 0){
            Role.onWantMoveX(Role.hurtData.away[2]);
            if(Role.hurtData.away[2] > 0){
                Role.hurtData.away[2] -= Scene.G_away;
                if(Role.hurtData.away[2] <0)Role.hurtData.away[2]=0;
            }else{
                Role.hurtData.away[2] += Scene.G_away;
                if(Role.hurtData.away[2]>0)Role.hurtData.away[2]=0;
            }
        }
        if(Role.hurtData.away[3] > 0){
            //TODO 重砸弹起
        }
    }
    /** 浮空状态：击飞+浮空 **/
    protected function onSkyEnterF():void{
        if(Role.y==0 && Role.hurtData.spdUp<0 && Role.hurtData.away[1]==0 && Role.hurtData.away[2]==0 && Role.hurtData.away[3]==0){
            onActEndF();
            return;
        }
        onAwayEnterF();
        if(Role.hurtData.spdUp > 0){
            Role.onWantMoveZ(Role.hurtData.spdUp);
            if(Role.hurtData.spdUp <= Scene.G){
                Role.hurtData.spdUp=0;
            }else{
                Role.hurtData.spdUp -=Scene.G;
            }
        }
        else{
            Role.onWantMoveZ(Role.hurtData.spdUp);
            Role.hurtData.spdUp -=Scene.G;
            if(Role.z <= 0){//判断落地
                if(Role.nowGroundType!=8){
                    Role.onWantMoveZ(-Role.z);
                    onActEndF();
                }else{
                    Role.onFalling();
                }
            }
        }
    }
    
    override protected function onAtLastFrame():void {
        nowIndex--;
    }

    override protected function onActEndF():void {
        isEnd=true;
        if(Role.nowAction==this){
            if(Role.hurtData && Role.hurtData.isKeepPose==false){
                Role.onWantChangeAction(SData_Strings.ActionName_leiDown);
            }else {
                Role.onWantChangeAction(SData_Strings.ActionName_Stand);
            }
        }
    }

    override public function breakF():void {
        super.breakF();
		Role.hurtData=Tool_ObjUtils.destroyF_One(Role.hurtData);
    }
}
}
