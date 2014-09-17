package as3TankLib.manager
{
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;

	/**
	 * 滤镜管理器
	 * @author Leo
	 */	
	public class FiltersManager
	{
		public function FiltersManager()
		{
		}
	
		private static var _hightBrightFilter:Array = [new GlowFilter(0xffffff,0.3,64,64,6,1,true)];
		/**
		 * 高亮 
		 * @return
		 * 
		 */		
		public static function get hightBrightFilters():Array
		{
			return _hightBrightFilter;
		}
		
		
		
		private static const colorMatrixFilterArray:Array = [new ColorMatrixFilter([
			1, 0, 0, 0, 0,
			1, 0, 0, 0, 0,
			1, 0, 0, 0, 0,
			0, 0, 0, 1, 0
		])];
		/**
		 * 获取灰色滤镜值
		 * @return Array
		 */
		public static function get greyFilters():Array
		{
			return colorMatrixFilterArray;
		}
		
		private static const _slightGreyFilter:Array = [new ColorMatrixFilter([0.3086
			, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094
			, 0.082, 0, 0, 0, 0, 0, 1, 0])];
		/**
		 * 获取浅灰色滤镜值
		 */
		public static function get slightGreyFilter():Array
		{
			return _slightGreyFilter;
		}
		
		private static const _yellowFilter:Array = [new GlowFilter(0xffff00, 1
			, 6, 6, 3)];
		/**
		 *获取黄色滤镜值
		 */
		public static function get yellowFilter():Array
		{
			return _yellowFilter;
		}
		
		private static const _redFilter:Array = [new GlowFilter(0xff0000, 1
			, 6, 6, 3)];
		/**
		 *获取红色滤镜值
		 */
		public static function get redFilter():Array
		{
			return _redFilter;
		}
		
		
	}
}