package Games.Fights.FightActions{
import Games.Controller_Scene;
import Games.Datas.Data_Attack;
import Games.Datas.Data_AttackArea;
import Games.Datas.Data_FActionStep;
import Games.Fights.FightRole;
import Games.Models.AttackModel;
import Games.Models.SkillModel;

import com.MyClass.Tools.Tool_ArrayUtils;

import com.MyClass.Tools.Tool_Function;
import com.MyClass.Tools.Tool_HitTest;

import com.MyClass.Tools.Tool_ObjUtils;

import Games.Fights.Fight_ActionCD;
import Games.Fights.Fight_ActionCost;

public class FAction_SkillDefault extends FAction_Default{
	public var skillmodel:SkillModel;
	public var cd:Fight_ActionCD;
	public var cost:Fight_ActionCost;
	public var Arr_aniStep:Array;//动画步骤，null表示播放完
	private var _nowStep:int;//当前动画的步骤
	protected var hits:*;//命中数据
	
	public function FAction_SkillDefault(){
        isSpdEffectByValue="攻速";
	}
	public function initFromSkillModel(sm:SkillModel):void{
		skillmodel=sm;
		if(sm.cd>0) {
            cd = new Fight_ActionCD(Role, this);
        }
        if(skillmodel.costValue!=null) {
            cost = new Fight_ActionCost(Role,skillmodel);
        }
		Arr_aniStep=skillmodel.Steps;
	}
	
	override public function canUse():Boolean	{
		if(cd && cd.canUse()==false){
			return false;
		}
		if(cost && cost.canUse() == false){
			return false;
		}
		return super.canUse();
	}
	
	override public function resetF():void{
		if(cd){
			cd.resetF();
		}
		nowStep=0;
		Role.IronCon.onClearF();
        if(hits==null){
			hits=Tool_ObjUtils.getNewObjectFromPool();
        }else{
			Tool_ObjUtils.onClearObj(hits);
		}
		super.resetF();
	}
	
	override protected function nextFrame():void {
		var rsm:Data_FActionStep=Arr_aniStep[nowStep];
		if(rsm==null || rsm.Arr_frame==null || rsm.loop==true){//没有帧数据，表示必然是循环播放动画！
			if(Role.mapRole && Role.mapRole.Role){
				nowIndex++;
				if(nowIndex >= Role.mapRole.Role.totalFrames){
					if(rsm.loop==true) {
						nowIndex = 0;
					}else{
						nextStep();
					}
				}
			}
		}else{
			if(nowIndex+1>=rsm.Arr_frame.length){
				nextStep();
			}else{
				nowIndex++;
			}
		}
		onCheckToPlaySound();
		setRoleFrameToIndex();
		onDoFrameEvent();
	}
	/** 技能的nowIndex只是在step中的下标，不是帧 */
    override protected function setRoleFrameToIndex():void {
        if(Role.mapRole.Role!=null && isEnd==false){
            var rsm:Data_FActionStep=Arr_aniStep[nowStep];
			if(rsm && rsm.Arr_frame) {
                Role.mapRole.Role.currentFrame = rsm.Arr_frame[nowIndex];
            }
        }
    }
	/** 直接获得当前帧 */
	protected function get nowFrame():int{
        var rsm:Data_FActionStep=Arr_aniStep[nowStep];
        if(rsm && rsm.Arr_frame) {
           return rsm.Arr_frame[nowIndex];
        }
		return nowIndex;
	}

    override protected function onDoFrameEvent():void {
		if(isEnd==true){return;}
        setGodEndure();
        checkAttack();
		checkCreatFly();
		//TODO 生成己方buff
	}
    /** 设置霸体、无敌等 **/
	protected function setGodEndure():void{
        var rsm:Data_FActionStep=Arr_aniStep[nowStep];
        if(rsm.isEndure==true){
            if(rsm.frameEndure==null){
				addEndure();
            }else if(rsm.frameEndure.indexOf(nowFrame) != -1){
				addEndure();
			}else{
				removeEndure();
			}
        }
        if(rsm.isGod==true){
            if(rsm.frameGod==null){
                addGod();
            }else if(rsm.frameGod.indexOf(nowFrame) != -1){
                addGod();
            }else{
                removeGod();
            }
        }
	}
	/** 检测攻击**/
	protected function checkAttack():void{
        var rsm:Data_FActionStep=Arr_aniStep[nowStep];
		if(rsm.attackInfo){
			for(var i:int=0;i<rsm.attackInfo.length;i++){
                checkAttackOne(rsm.attackInfo[i]);
			}
		}
	}
	/** 检测一次攻击 **/
	protected function checkAttackOne(data:Data_Attack):void{
		if(data.isInFrames(nowFrame)==false){return;}
        Controller_Scene.getInstance().nowScene.getAllFightRolesByCamp(_checkAttackOne,-Role.camp);
        function _checkAttackOne(tar:FightRole):Boolean{
			if(tar == Role)return false;
			//检测重复
			if(data.isMultihit==false){
				if(hits[tar.netID]!=null)return false;
			}
            //检测范围
            var tarArea:Data_AttackArea =tar.hitArea;
			var tarx:Number=tar.x - Role.x;
			var tary:Number=tar.y - Role.y;
            for(var i:int=0;i<data.Areas.length;i++){
                var one:Data_AttackArea =data.Areas[i];
                var onePoints:Array;
                if(Role.nowDirection==1){
                    onePoints=one.getScaleXPoints();
                }else {
                    onePoints = one.points;
                }
				//倒地状态
				if(tar.nowAction && tar.nowAction.Name=="倒地" && one.canHitGound==false){continue;}
                if(tarArea!=null){
                    //先y轴
                    if(tary+tarArea.yDown >= -one.yUp  &&  tary-tarArea.yUp <= one.yDown){
                        //再多边形
                        var newPoint:Array =tarArea.getLocalPoints(Role,tarx,tary);
                        var suc:Boolean =Tool_HitTest.onHitTestEclipse(onePoints,newPoint);
                        Tool_ArrayUtils.returnArrayToPool(newPoint);
                        if(suc==true){
                            onHitOne(tar,data);
                            return true;
                        }
                    }
                }else{//没有碰撞范围的角色，默认为一个点
                    //先y轴
                    if(tary >= -one.yUp  &&  tary <= one.yDown){
                        //再多边形
                        suc =Tool_Function.onPointInEclipse(onePoints,null,tarx,tary);
                        if(suc==true){
                            onHitOne(tar,data);
                            return true;
                        }
                    }
                }
                if(onePoints != one.points){
                    Tool_ArrayUtils.returnArrayToPool(onePoints);
                }
            }
            return false;
        }
	}
	/** 成功攻击 **/
	protected function onHitOne(tar:FightRole,data:Data_Attack):void{
		var atk:AttackModel=new AttackModel(Role,data);
		tar.beHurt(atk);
		if(hits[tar.netID]==null)hits[tar.netID]=0;
		hits[tar.netID]++;
	}
	/** 检测释放飞行物体 **/
	protected function checkCreatFly():void{
        var rsm:Data_FActionStep=Arr_aniStep[nowStep];
        if(rsm.flyobjInfo){
			//TODO 生成飞行物体
        }
	}
	
	/** 下一个步骤动作 */
	public function nextStep():void{
		if(isLoopAni == false){
			if(nowStep+1 >=Arr_aniStep.length){
				onActEndF();
				return;
			}
			nowStep++;
			onChangeRoleMcByURL();
		}
        Tool_ObjUtils.onClearObj(hits);
		nowIndex=0;
        setGodEndure();
	}
	
	public function get nowStep():int {return _nowStep;	}
	public function set nowStep(value:int):void {
		_nowStep = value;
		var rsm:Data_FActionStep=Arr_aniStep[_nowStep];
		swf=rsm.swf;
		url=rsm.url;
		soundData=rsm.soundInfo;
		isLoopAni=rsm.loop;
		hitArea=rsm.hitArea;
	}
	
	override public function breakF():void	{
		super.breakF();
	}
	override public function destroyF():void{
		cd=Tool_ObjUtils.destroyF_One(cd);
		cost=Tool_ObjUtils.destroyF_One(cost);
        hits=Tool_ObjUtils.destroyF_One(hits);
		super.destroyF();
	}
	
	
	
}
}