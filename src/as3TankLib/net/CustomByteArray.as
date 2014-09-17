package as3TankLib.net
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 *@author Leo
	 */
	public class CustomByteArray extends ByteArray
	{
		public function CustomByteArray()
		{
			super();
			this.endian = Endian.BIG_ENDIAN;
		}
	}
}