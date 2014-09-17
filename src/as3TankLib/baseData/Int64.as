package as3TankLib.baseData
{
	
	/**
	 *@author Leo
	 */
	public class Int64
	{
		public function Int64(value:Number)
		{
			this.value = value;
			this.size = 64;
		}
		
		public var value:Number;
		public var size:int;
		
		public function toString():String
		{
			return value.toString();
		}
		
	}
}