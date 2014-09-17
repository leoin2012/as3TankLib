package as3TankLib.enum
{
	/**
	 * 游戏层
	 *@author Leo
	 */
	public class GameLayer
	{
		public function GameLayer()
		{
		}
		/** 最底层 */
		public static const BOTTOM_LAYER:int = 0;
		/** 场景层 */
		public static const SCENE_LAYER:int = 1;
		/** UI层 */
		public static const UI_LAYER:int = 2;
		/** 特效层 */
		public static const EFFECT_LAYER:int = 3;
		/** 主菜单层 */
		public static const MENU_LAYER:int = 4;
		/** 加载层 */
		public static const LOADING_LAYER:int = 5;
		/** 提示信息层 */
		public static const MSG_LAYER:int = 6;
		/** 最顶层 */
		public static const TOP_LAYER:int = 7;
		
		/** 检测层是否合法 */
		public function checkValid(layerIndex:int):Boolean
		{
			return (BOTTOM_LAYER < layerIndex && TOP_LAYER > layerIndex);
		}
	}
}