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
		public static const ActionName_Stand:String="站立";
		public static const ActionName_Run:String="跑步";
        public static const ActionName_RunStop:String="急停";
        public static const ActionName_Jump:String="跳";
        public static const ActionName_Hurt:String="挨打";
        public static const ActionName_leiDown:String="倒地";
        public static const ActionName_NorAttack:String="X";//普攻
        public static const ActionName_Skill:String="技能";
		
		//SWF
		public static const SWF_DefaultUI:String="SWF_Default";
        public static const SWF_FightUI:String="SWF_Fight";
		/****************************游戏中显示使用，随语言环境变化***********************************/
		public	static var Alert_Error:String="游戏出现意外错误，请重新启动！";
		public	static var Alert_ErrorTitle:String="哎呀出错了";
		public	static var Alert_badNet:String="联网失败！请检查网络！";
		public	static var Loading_netting:String="联网中";
		/********************************  游戏中设置相关，不随语言变化 *********************************/
		public	static const LOCS_LoginInfo:String="账号密码";
		public	static const LOCS_SoundControl:String="声音信息";
		public	static const LOCS_SoundControl_volume:String="声音信息_音量";
		public	static const SD_Default_SaveLoginNum:String="保存账号数量";
	}
}