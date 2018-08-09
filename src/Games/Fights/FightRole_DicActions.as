package Games.Fights {
import Games.Datas.Data_RoleSkills;
import Games.Fights.FightActions.FAction_Hurt;
import Games.Fights.FightActions.FAction_Jump;
import Games.Fights.FightActions.FAction_RunStop;
import Games.Fights.FightActions.FAction_SkillDefault;
import Games.Models.SkillModel;

import StaticDatas.SData_RolesInfo;

import com.MyClass.Tools.Tool_Function;

import com.MyClass.Tools.Tool_ObjUtils;

import Games.Fights.FightActions.FAction_Run;
import Games.Fights.FightActions.FAction_Stand;

import StaticDatas.SData_Strings;

/**
 * 战斗所有动作
 * */
public class FightRole_DicActions {
    private var Role:FightRole;
    private var Dic:* =Tool_ObjUtils.getNewObjectFromPool();
    
    public function FightRole_DicActions(fr:FightRole) {
        Role=fr;
        var info:* =SData_RolesInfo.getInstance().Dic[fr.baseRoleMo.baseID];
        //站立
        var stand:FAction_Stand=new FAction_Stand(fr);
        stand.initF(info[SData_Strings.ActionName_Stand]);
        Dic[SData_Strings.ActionName_Stand]=stand;
        //跑动
        if(info[SData_Strings.ActionName_Run]!=null){
            var run:FAction_Run =new FAction_Run(fr);
            Dic[SData_Strings.ActionName_Run]=run;
            run.initF(info[SData_Strings.ActionName_Run]);
        }
        //急停
        if(info[SData_Strings.ActionName_RunStop]!=null){
            var runstop:FAction_RunStop=new FAction_RunStop(fr);
            Dic[SData_Strings.ActionName_RunStop]=runstop;
            runstop.initF(info[SData_Strings.ActionName_RunStop]);
        }
        //跳
        if(info[SData_Strings.ActionName_Jump]!=null){
            var jump:FAction_Jump=new FAction_Jump(fr);
            Dic[SData_Strings.ActionName_Jump]=jump;
            jump.initF(info[SData_Strings.ActionName_Jump]);
        }
        //挨打
        var hurt:FAction_Hurt=new FAction_Hurt(fr);
        Dic[SData_Strings.ActionName_Hurt]=hurt;
        //技能：主动且已装备、普攻
        if(fr.infoFight && fr.infoFight["技能"]){
            var skills:Data_RoleSkills = fr.infoFight["技能"];
            for(var i:int=0;i<skills.Arr_haveSkill.length;i++){
                var skill:SkillModel =skills.Arr_haveSkill[i];
                if(skill.isPassive==false && skills.isEquip(skill.SID)!=null){
                    var skillAction:FAction_SkillDefault =getSkillActionFromSkill(skill);
                    if(skillAction){
                        skillAction.keyborad =  skills.isEquip(skill.SID);
                        Dic[SData_Strings.ActionName_Skill + skillAction.keyborad]=skillAction;
                    }
                }
            }
            if(skills.norAttack){
                skillAction =getSkillActionFromSkill(skills.norAttack);
                if(skillAction){
                    Dic[SData_Strings.ActionName_NorAttack]=skillAction;
                }
            }
        }
    }
    /** 临时方法，生成技能action */
    private function getSkillActionFromSkill(skill:SkillModel):FAction_SkillDefault{
        var skillAction:FAction_SkillDefault;
        if(skill.className!=null){
            if(skill.className.indexOf("Games.")==-1){
                skillAction = Tool_Function.onNewClass("Games.Fights.FightActions."+skill.className);
            }else {
                skillAction = Tool_Function.onNewClass(skill.className);
            }
        }else{
            skillAction=new FAction_SkillDefault();
        }
        if(skillAction){
	        skillAction.Role=this.Role;
            skillAction.initFromSkillModel(skill);
        }
        return skillAction;
    }
    
    public function hasAction(key:String):Boolean{
        if(Dic[key]==null)return false;
        return true;
    }
    public function getActionByName(key:String):*{
        return Dic[key];
    }
    
    public function destroyF():void{
        Dic=Tool_ObjUtils.destroyF_One(Dic);
    }
}
}
