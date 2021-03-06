package StaticDatas{
import Games.Fights.FightBuffs.FightBuff_Default;

import com.MyClass.VertionVo;
	import com.MyClass.Tools.Tool_Function;
	
	public class SData_Buff{
		//生成条件
		public static const TypeCreat_must:String="必定";
		public static const TypeCreat_hit:String="命中";
		//持续方式
		public static const TypeLast_time:String="时间";
		public static const TypeLast_forever:String="永久";
		public static const TypeLast_linkFromBuff:String="关联来源buff";
		public static const TypeLast_linkSelfBuff:String="关联自身buff";
		//叠加方式
		public static const TypeSuperpose_single:String="单例";
		public static const TypeSuperpose_need:String="叠加";
		public static const TypeSuperpose_only:String="唯一";
		//生效条件
		public static const TypeAct_always:String="必定";
		public static const TypeAct_haveBadBuff:String="有异常状态";
		public static const TypeAct_Cost:String="消耗";
		public static const TypeAct_isLowHp:String="生命低于";
		//生效时间
		public static const BuffCheckType_BuffStart:String="生成";
		public static const BuffCheckType_BuffEnd:String="结束";
		public static const BuffCheckType_ActionStart:String="回合开始";
		public static const BuffCheckType_ActionEnd:String="回合结束";
		public static const BuffCheckType_攻击前:String="攻击前";
		public static const BuffCheckType_攻击后:String="攻击后";
		public static const BuffCheckType_被击前:String="被攻击前";
		public static const BuffCheckType_被击后:String="被攻击后";
		public static const BuffCheckType_被Buff攻击:String="buff攻击后";
		public static const BuffCheckType_BePureHP:String="HP恢复";
		public static const BuffCheckType_getValues:String="获得属性";
		public static const BuffCheckType_otherBuff:String="其他buff生成";
		//生效效果
		public static const TypeEffect_valuesAdd:String="增加属性";
		public static const TypeEffect_recoverl:String="治疗";
		public static const TypeEffect_stop:String="无法行动";
		public static const TypeEffect_Silence:String="沉默";
		public static const TypeEffect_Noner:String="无";//无其他效果
		public static const TypeEffect_hurtMore:String="额外伤害";//造成第二次伤害
		public static const TypeEffect_breakSkill:String="中断技能";
		public static const TypeEffect_newBuff:String="额外buff";
		//显示
		public static const TypeAniPosition_bottom:String="下";
		public static const TypeAniPosition_middle:String="中";
		public static const TypeAniPosition_top:String="上";
		
		private static var instance:SData_Buff;
		public static function getInstance():SData_Buff
		{
			if(instance==null){
				instance=new SData_Buff();
			}
			return instance;
		}
		
		public static function getBuffByID(id:*,role:*, info:* =null):*{
			var dic:* =getInstance().Dic[id];
			if(dic==null){
				trace("没有该buff:"+id);
				return null;
			}
			if(dic["class"] != null){
				if(Tool_Function.isTypeOf(dic["class"],String) == true){
					var str:String=dic["class"];
					if(str.indexOf(".")==-1 && str.indexOf(":")==-1){
						return Tool_Function.onNewClass("Games.Fights."+str,role,dic,info);
					}else{
						return Tool_Function.onNewClass(str,role,dic,info);
					}
				}else{
					return Tool_Function.onNewClass(dic["class"],role,dic,info);
				}
			}
			return Tool_Function.onNewClass(FightBuff_Default,role,dic,info);
		}
		
		public var Dic:*;
		public function SData_Buff()
		{
			Dic=VertionVo.getData(this);
			if(Dic==null){
				onLocal();
			}
		}
		
		private function onLocal():void
		{
			Dic={};
			var id:*;
			var dic:*;
			//==================

}
		
	}
}