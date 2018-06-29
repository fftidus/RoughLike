package StaticDatas
{
	import Games.Models.ArmorModel;
	import Games.Models.GameObjectModel;
	import Games.Models.ItemModel;
	import Games.Models.MaterialModel;
	import Games.Models.WeaponModel;

	public class SData_Strings
	{
		public static function setLanguage(lag:String = null):void
		{
			if(lag=="ENG")
			{
				
			}
		}
		public static function getStringByGiftArray(arr:Array,strMid:String="\n"):String{
			var str:String="";
			for(var i:int=0;i<arr.length;i++){
				if(i>0){
					str+=strMid;
				}
				var obj:GameObjectModel =arr[i];
				if(obj.Type=="金币" || obj.Type=="钻石"){
					str+=obj.Type+" x"+obj.Num;
				}else if(obj.Type=="武器"){
					var wea:WeaponModel =obj.wea;
					if(wea){
						str+=wea.Name;
					}
				}else if(obj.Type=="防具"){
					var arm:ArmorModel =obj.arm;
					if(arm){
						str+=arm.Name;
					}
				}else if(obj.Type=="道具"){
					var item:ItemModel =obj.item;
					if(item){
						str+=item.Name + " x"+obj.Num;
					}
				}else if(obj.Type=="素材"){
					var mat:MaterialModel =obj.mat;
					if(mat){
						str+=mat.Name + " x"+obj.Num;
					}
				}
			}
			return str;
		}
		
		/****************************SWF使用，不跟随语言环境变化***********************************/
		//Action
		public static const ActionName_站立:String="站立";
		public static const ActionName_移动:String="移动";
		public static const ActionName_跑步:String="跑步";
		public static const ActionName_前进:String="前进";
		public static const ActionName_后退:String="后退";
		public static const ActionName_挨打:String="挨打";
		public static const ActionName_技能:String="技能";
		public static const ActionName_道具:String="道具";
		
		public static const BUFFEffect_伤害增加:String="伤害增加";
		//SWF
		public static const SWF_默认UI:String="SWF_Default";
		public static const IMG_透明:String="img_透明";
		public static const SPR_弹窗:String="spr_AlertWin";
		public static const SWF_Login:String="SWF_LoginView";
		public static const SWF_大厅:String="SWF_Hall";
		public static const SWF_Town:String="SWF_Town";
		public static const SWF_战斗界面:String="SWF_FightView";
		public static const SWF_角色界面:String="SWF_PackageView";
		public static const SWF_酒馆界面:String="SWF_Tavern";
		public static const SWF_编队界面:String="SWF_Formation";
		public static const SWF_商店界面:String="SWF_ItemShop";
		public static const SWF_仓库界面:String="SWF_StorageView";
		public static const SWF_CreatGem:String="SWF_CreatGem";
		public static const SWF_SkillVIew:String="SWF_SkillView";
		public static const SWF_TaskVIew:String="SWF_TaskView";
		public static const SWF_FubenView:String="SWF_Fuben";
		public static const SWF_FubenSelect:String="SWF_FubenSelect";
		public static const SWF_IconHead:String="SWF_IconHead";
		public static const SWF_IconWea:String="SWF_IconWea";
		public static const SWF_IconArm:String="SWF_IconArm";
		public static const SWF_IconItem:String="SWF_IconItem";
		public static const SWF_IconMat:String="SWF_IconMat";
		public static const SWF_IconSkill:String="SWF_IconSkill";
		/****************************游戏中显示使用，随语言环境变化***********************************/
		public	static var Alert_默认OK:String="确定";
		public	static var Alert_默认NO:String="取消";
		public	static var Alert_意外错误:String="游戏出现意外错误，请重新启动！";
		public	static var Alert_意外错误Title:String="哎呀出错了";
		public	static var Alert_联网失败:String="联网失败！请检查网络！";
		public	static var Alert_重连:String="重连";
		public	static var Alert_账号密码错误:String="请输入账号和密码！";
		public	static var Alert_重复密码错误:String="两次输入的密码不一致！";
		public	static var Alert_账号非法字符:String="账号中含有特殊的字符！";
		public	static var Alert_账号太长:String="账号长度超过限制！";
		public	static var Alert_绑定手机错误:String="暂时无法绑定手机！";
		public	static var Alert_手机号错误:String="请输入正确的手机号码！";
		public	static var Alert_验证码错误:String="验证码错误！";
		public	static var Alert_确认手机:String="即将向您输入的手机号发送验证短信，是否继续？";
		public	static var Alert_验证码发送失败:String="发送验证码失败！请确认您的手机号。";
		public	static var Alert_验证码发送成功:String="验证码短信已发送，请耐心等待！";
		public	static var Alert_验证码正在等待:String="请输入您收到的验证码后点击注册按钮！";
		public	static var Alert_验证码正在验证:String="正在验证，请稍后！";
		public	static var Alert_从出口回城:String="是否回城？";
		public	static var Alert_消耗卷轴回城:String="是否消耗1个【回城卷轴】回城？";
		public	static var Alert_传送门激活:String="该传送门已激活！";
		public	static var Alert_传送门需激活关联:String="暂时无法使用！请先激活对应的另一个传送门！";
		public	static var Alert_重复逃跑:String="本轮无法再次逃跑！";
		public	static var Alert_重置符文等级不足:String="需要角色等级x才能进行该操作！";
		public	static var Alert_询问符文重置:String="确认对该角色进行符文重置吗？\n消耗金币:x";
		public	static var Loading_联网中:String="联网中";
		/********************************  游戏中设置相关，不随语言变化 *********************************/
		public	static const LOCS_账号密码:String="账号密码";
		public	static const LOCS_声音信息:String="声音信息";
		public	static const LOCS_声音信息_音量:String="声音信息_音量";
		public	static const SD_Default_保存数量:String="保存账号数量";
	}
}