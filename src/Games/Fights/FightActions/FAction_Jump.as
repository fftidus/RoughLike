package Games.Fights.FightActions {
import Games.Fights.FightRole;

import com.MyClass.Config;

import starling.utils.deg2rad;

public class FAction_Jump extends FAction_Default{
    private var nowFlag:int=0;
    private var dicUrls:* ={};
    private var isFalling:Boolean;
    private var LAll:int;//跳跃力
    private var nowSpd:Number;
    private var spdMove:Number;
    private static var G:Number=0;
    
    public function FAction_Jump(fr:FightRole) {
        Role=fr;
        Name="跳";
        if(G==0){
            G=50/Config.playSpeedTrue;
        }
    }

    override public function initF(info:*):void {
        super.initF(info);
        if(info){
            dicUrls[0]=info["url起跳"];
            dicUrls[1]=info["url上升"];
            dicUrls[2]=info["url下落"];
            dicUrls[3]=info["url落地"];
        }
    }
    private function nextFlag():void{
        nowFlag++;
        if(nowFlag>=4){
            onActEndF();
        }else{
            url=dicUrls[nowFlag];
            nowIndex=0;
            nowCountMSecond=0;
            onChangeRoleMcByURL();
        }
    }

    override public function resetF():void {
        LAll=Role.getValue("跳跃力");
        if(LAll==0)LAll=1000/Config.playSpeedTrue;
	    var spd:Number =Role.getValue("移速");
	    if(spd<0)spd=0;
	    spdMove= spd / Config.playSpeedTrue;
        if(Role.nowGroundType ==8){//落下
            nowFlag=2;
            nowSpd=0;
	        isFalling=true;
            //改变层级到地面层
            Role.mapRole.map.addMapObjectToLayer(Role.mapRole,1);
        }else{//起跳
            nowFlag=0;
            nowSpd=LAll;
	        isFalling=false;
        }
        url=dicUrls[nowFlag];
        super.resetF();
    }

    override public function enterF():void {
        if(nowFlag==1){
            Role.onWantMoveZ(nowSpd);
            nowSpd-=G;
            if(nowSpd<=0){
                nowSpd=0;
                nextFlag();
            }else{
	            checkKeyController();
            }
        }
        else if(nowFlag==2){
            Role.onWantMoveZ(-nowSpd);
            nowSpd+=G;
            if(Role.z<=0){
                if(Role.nowGroundType!=8){
                    Role.onWantMoveZ(-Role.z);
                    nextFlag();
                }else{
                    if(isFalling==false){
                        isFalling=true;
                        Role.mapRole.map.addMapObjectToLayer(Role.mapRole,1);
                    }
                    if(Role.z<-200){
                        //TODO 死亡
                        Role.mapRole.z =-200;
//	                    Role.mapRole.map.addMapObjectToLayer(Role.mapRole);//复活
                        Role.onDeadF();
                    }
                }
            }else{
	            checkKeyController();
            }
        }
        super.enterF();
    }

    override protected function onAtLastFrame():void {
        if(nowFlag==1 || nowFlag==2){
            nowIndex=0;
        }else{
            nextFlag();
        }
    }
	
	override protected function checkKeyController():void {
        if(isFalling==true){ return;  }
		if(Role.controller==null){return;}
		var ang:int =Role.controller.nowMoveAng;
        if(ang==-1){return;}
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
}
