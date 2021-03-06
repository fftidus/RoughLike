package Games.Fights.FightActions {
import Games.Datas.Data_Sound;

import StaticDatas.SData_EventNames;

import com.MyClass.Config;

import Games.Fights.FightRole;

import StaticDatas.SData_Strings;

import com.MyClass.MainManager;

import starling.utils.deg2rad;

public class FAction_Run extends FAction_Default{
    private var spdMove:Number=0;
    private var countRun:int;
    public function FAction_Run(fr:FightRole) {
        Role=fr;
        Name="移动";
        isLoopAni=true;
    }
    override public function initF(info:*):void {
        super.initF(info);
    }

    override public function checkCanStopByItem():Boolean{
        return true;
    }
    override public function resetF():void{
        super.resetF();
        Role.IronCon.onClearF();
        countRun=0;
        checkSpd();
    }
    /** 计算真实移速，外部的移速是每秒移动距离，这里换算为每帧 */
    public function checkSpd():void{
        var spd:Number =Role.getValue("移速");
        if(spd<0)spd=0;
        spdMove= spd / Config.playSpeedTrue;
        var spdmore:int =spd - Role.getBaseValue("移速");
        if(spdmore>0){//y = x/(x+0.5)		厂形状弧线，永不达到1
            perMSofFrame += spdmore / (spdmore + 60);
        }else if(spdmore<0){
            perMSofFrame -= -spdmore / (-spdmore + 50);
        }
    }

    override public function enterF():void{
        countRun++;
        super.enterF();
        if(onCheckFallDown()==true){
            return;
        }
        checkKeyController();
    }

    override protected function onCheckToPlaySound():void {
        if(soundData && soundData.dicFrame && soundData.dicFrame[nowIndex] != null){
            var soundone:Data_Sound =Data_Sound.getNewData(soundData.dicFrame[nowIndex],Role.x,Role.y);
            MainManager.getInstence().MEM.dispatchF(SData_EventNames.Scene_Sound+Role.mapRole.nowGroundType,soundone);
        }
    }

    /** 检查操作 */
    override protected function checkKeyController():void{
        if(Role.controller==null){//错误？？？？
            onActEndF();
            return;
        }
	    if(checkKey_Jump()==true){
		    return;
	    }
        if(checkKey_NormalAttack()==true){
            return;
        }
        var ang:int =Role.controller.nowMoveAng;
        if(ang==-1){
            onActEndF();
            return;
        }
        if((ang>180 && Role.nowDirection!=1) || (ang<180 && ang>0 && Role.nowDirection!=0)){//不同方向
            if(neetStopAct()==false){//直接转身
                countRun=0;
                if(ang==0 || ang==180){}
                else if(ang>180){
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

    override protected function onAtLastFrame():void {
        super.onAtLastFrame();
        
    }

    /** 是否需要急停 */
    private function neetStopAct():Boolean{
        var time:Number =countRun / Config.playSpeedTrue;
        if(time>=1)return true;
        return false;
    }

    override protected function onActEndF():void{
        if(Role.mapRole.nowGroundType==8){
            super.onActEndF();
            return;
        }
        if(neetStopAct()==true){
            Role.onWantChangeAction(SData_Strings.ActionName_RunStop);
        }else{
            super.onActEndF();
        }
    }
    
}
}
