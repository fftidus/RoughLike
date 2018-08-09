package Games.Datas {
import Games.Models.RoleModel;
import Games.Models.SkillModel;

import StaticDatas.SData_RolesInfo;
import StaticDatas.SData_Skills;

import com.MyClass.Config;

import com.MyClass.Tools.Tool_ObjUtils;

/**
 * 角色的技能数据：拥有技能，携带技能，技能升级
 * */
public class Data_RoleSkills {
    private var RM:RoleModel;
	private var netInfo:*;
    /** 普攻ID */
    public var norAttack:SkillModel;
    /** 拥有的技能id */
    public var Arr_haveSkill:Array=[];
    /** 技能升级数据：{"等级":int} */
    public var Dic_skillInfo:*;
    /** 装备技能 */
    public var Dic_Equip:*;
    
    
    public function Data_RoleSkills(rm:RoleModel,info:*) {
        RM=rm;
	    netInfo=info;
        //角色静态属性
        var norAttackID:int=SData_RolesInfo.getInstance().Dic[rm.baseID]["普攻"];
        if(norAttackID > 0) {
            norAttack = new SkillModel(norAttackID);
            norAttack.Lv=1;
            norAttack.initF();
        }
        var basehave:Array=SData_RolesInfo.getInstance().Dic[rm.baseID]["拥有技能"];
        //角色网络属性
        Dic_Equip=info["装备"];
        Dic_skillInfo=info["学习"];
        for(var i:int =0 ;i<basehave.length;i++){
            var skill:SkillModel=new SkillModel(basehave[i]);
            skill.Lv =getSkillRealLv(skill.SID);
	        skill.LvMax =getSkillMaxLv(skill.SID);
            skill.initF();
            Arr_haveSkill[i]=skill;
        }
    }
    /** 获得某个技能学习的等级 */
    public function getSkillBaseLv(sid:int):int{
        if(Dic_skillInfo && Dic_skillInfo[sid]){
            return Dic_skillInfo[sid]["等级"];
        }
        return 0;
    }
    /** 获得某个技能最终的等级，可以被装备buff修改，被动技能buff不做修改其他技能等级的效果！ */
    public function getSkillRealLv(sid:int):int{
        var blv:int =getSkillBaseLv(sid);
        return blv;//暂不计算被装备修改
    }
    /** 获得某个技能的最大等级，如果Role静态数据中有上限则使用特殊上限，否则都是技能最大等级 */
	private function getSkillMaxLv(sid:int):int{
		if(netInfo["上限"] && netInfo["上限"][sid] != null){
		   return netInfo["上限"][sid];
		}
	    var dic:* =SData_Skills.getInstance().Dic[sid];
	    if(dic==null){
		    Config.Log("没有找到技能数据"+sid);
		    return 1;
	    }
	    if (dic["升级"] != null) {
		    var tlv:int = 2;
		    while (dic["升级"][tlv] != null) {
			    tlv++;
		    }
		    return tlv-1;
	    }
	    return 1;
    }
    /** 根据sid获得skillModel */
    public function getSkillByID(sid:int):SkillModel{
        for(var i:int =0 ;i<Arr_haveSkill.length;i++){
            var skill:SkillModel=Arr_haveSkill[i];
            if(skill && skill.SID == sid){
                return skill;
            }
        }
        return null;
    }
    /** 是否装备了某个技能，是则返回装备的按键，未装备返回null */
    public function isEquip(sid:int):String{
        var skill:SkillModel = getSkillByID(sid);
        if(skill && Dic_Equip){
            for(var key:String in Dic_Equip){
                if(Dic_Equip[key]==sid){
                    return key;
                }
            }
        }
        return null;
    }
    
    public function destroyF():void{
        RM=null;
        norAttack=Tool_ObjUtils.destroyF_One(norAttack);
        Arr_haveSkill=Tool_ObjUtils.destroyF_One(Arr_haveSkill);
    }
}
}
