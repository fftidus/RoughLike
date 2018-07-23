package Games.Fights.FightActions {
import Games.Fights.FightRole;

import StaticDatas.SData_RolesInfo;

import com.MyClass.Config;

import starling.utils.deg2rad;

public class FAction_Run extends FAction_Default{
    private var spdMove:Number=0;
    private var countRun:int;
    public function FAction_Run(fr:FightRole) {
        Role=fr;
        Name="移动";
        Role=fr;
        isLoopAni=true;
        isEffectBySpd=false;
    }
    override public function checkCanStopByItem():Boolean{
        return true;
    }
    override public function resetF():void{
        super.resetF();
        countRun=0;
        checkSpd();
    }
    /** 计算真实移速，外部的移速是每秒移动距离，这里换算为每帧 */
    public function checkSpd():void{
        var spd:Number =Role.getValue("移速");
        if(spd<0)spd=0;
        spd=100;
        spdMove= spd / Config.playSpeedTrue;
        perMSofFrame += spdMove / (spdMove + 60);
    }

    override public function enterF():void{
        countRun++;
        super.enterF();
        checkKeyController();
    }

    /** 检查操作 */
    override protected function checkKeyController():void{
        if(Role.controller==null){//错误？？？？
            onActEndF();
            return;
        }
        var ang:int =onCheckNowAngle();
        if(ang==-1){
            onActEndF();
            return;
        }
        if((ang>180 && Role.nowDirection!=1) || (ang<180 && ang>0 && Role.nowDirection!=0)){//不同方向
            if(neetStopAct()==false){//直接转身
                countRun=0;
                if(ang>180){
                    Role.onChangeDirect("左");
                }else{
                    Role.onChangeDirect("右");
                }
            }else{//先进入急停动作
                onActEndF();
            }
        }else{//移动速度计算
            var spdx:Number;
            var spdy:Number;
			if(ang==90){
				spdx=spdMove;
				spdy=0;
			}
			else if(ang==270){
				spdx=-spdMove;
				spdy=0;
			}
			else if(ang==180){
				spdx =0;
				spdy =spdMove;
			}else{
            	spdx =Math.sin(deg2rad(ang)) * spdMove;
            	spdy =-Math.cos(deg2rad(ang)) * spdMove;
			}
            Role.onWantMoveX(spdx);
            Role.onWantMoveY(spdy);
        }
    }
    /** 计算当前操作器的方向角度 */
    private function onCheckNowAngle():int{
        if(Role.controller.isdown_Left()==true){
            if(Role.controller.isdown_Up()==true){
                return 270+45;
            }else if(Role.controller.isdown_Down()==true){
                return 270-45;
            }
            return 270;
        }
        else if(Role.controller.isdown_Right()==true){
            if(Role.controller.isdown_Up()==true){
                return 45;
            }else if(Role.controller.isdown_Down()==true){
                return 90+45;
            }
            return 90;
        }
        else  if(Role.controller.isdown_Up()==true){
            return 0;
        }
        else if(Role.controller.isdown_Down()==true){
            return 180;
        }
        return -1;
    }
    
    /** 是否需要急停 */
    private function neetStopAct():Boolean{
        var time:Number =countRun / Config.playSpeedTrue;
        if(time>=1)return true;
        return false;
    }

    override protected function onActEndF():void{
        if(neetStopAct()==true){
            Role.onWantChangeAction(SData_RolesInfo.ActionName_RunStop);
        }else{
            super.onActEndF();
        }
    }
    
}
}
