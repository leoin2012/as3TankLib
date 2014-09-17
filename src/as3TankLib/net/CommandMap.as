package as3TankLib.net
{
	import as3TankLib.util.Debuger;
	
	import flash.utils.Dictionary;

	/**
	 * 协议数据实体映射类
	 *@author Leo
	 */
	public class CommandMap
	{
		/**
		 * 存放Cmd映射的数据类 
		 */		
		public static var _CMDDic:Dictionary;
		/**
		 *  缓存数据类所拥有字段的字典
		 */		
		public static var _reflectionDic:Dictionary;
		
		public function CommandMap()
		{
			_CMDDic = new Dictionary();
			_reflectionDic = new Dictionary();
		}
		
		/**
		 * 根据协议获取对应数据类
		 * @param cmd
		 * @return 
		 */		
		public static function getCMDObject(cmd:int):Object
		{
			if(_CMDDic[cmd] == undefined)
			{
				Debuger.show(Debuger.SOCKET, "没有配置该协议对应的类" + cmd);
				return null;
			}
			
			return _CMDDic[cmd];
		}
		
		/**
		 * 缓存一个数据类所有字段
		 * @param valueObject
		 * @param objectFields
		 */		
		public static function putClassFields(valueObject:Object, objectFields:Array):void
		{
			_reflectionDic[valueObject] = objectFields;
		}
		
		/**
		 * 获取一个数据类的所有字段
		 * @param valueObject
		 * @return 
		 */		
		public static function getClassFields(valueObject:Object):Array
		{
			if(_reflectionDic[valueObject] == undefined)return null;
			
			return _reflectionDic[valueObject];
		}
		
	}
}