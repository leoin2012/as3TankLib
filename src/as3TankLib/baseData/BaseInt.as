package as3TankLib.baseData
{
	/**
	 *@author Leo
	 */
	public class BaseInt
	{
		/**
		 * 对应的数值（int存储） 
		 */		
		public var value:int;
		
		/**
		 * 代表的数的位数大小 
		 */		
		public var size:int;
		
		public function BaseInt(value:Number = 0)
		{
			super();
			this.value=value;
		}
		public function toString():String
		{
			return 	value.toString();
		}
	}
}