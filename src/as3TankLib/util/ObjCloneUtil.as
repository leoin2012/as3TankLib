package as3TankLib.util
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	/**
	 * 对象拷贝工具
	 *@author Leo
	 */
	public class ObjCloneUtil
	{
		public function ObjCloneUtil()
		{
		}
		
		/** 克隆一个对象（用ByteArray做对象拷贝）克隆前先registerClassAlias  */
		public static function cloneObject(obj:*):*
		{
			if(null == obj)return null;
			
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject(obj);
			byteArray.position = 0;
			return byteArray.readObject();
		}
		/**
		 * 拷贝显示对象
		 * @param source
		 * @param drawRect
		 * @return 
		 */		
		public static function cloneDisplayObject(source:DisplayObject, drawRect:Rectangle = null):Bitmap
		{
			if(source == null)return null;
			
			var bitmapData:BitmapData = new BitmapData(source.width, source.height);
			if(drawRect)
				bitmapData.fillRect(drawRect,0);
			else
				bitmapData.fillRect(new Rectangle(0, 0, source.width, source.height), 0);
			bitmapData.draw(source);
			var bitmap:Bitmap = new Bitmap(bitmapData);
			bitmapData = null;
			return bitmap;
		}
		
	}
}