package as3TankLib.ui
{
	import as3TankLib.util.Reflection;
	
	import flash.display.Sprite;

	/**
	 * 默认tooltip视图，只有文字和默认背景
	 *@author Leo
	 */
	public class ToolTipDefaultView extends BaseSprite
	{
		public function ToolTipDefaultView()
		{
			super();
			configUI();
		}
		/** 背景 */
		private var _bg:Sprite;
		/** 文本 */
		private var _text:CustomTextfield;
		
		private var _htmlText:String = "";
		/** 设置tips文本内容 */
		public function get htmlText():String
		{
			return _htmlText;
		}
		public function set htmlText(value:String):void
		{
			if(_htmlText == value || "" == value)
				return;
			_htmlText = value;
			update();
		}
		/** 配置UI */
		private function configUI():void
		{
			_bg = Reflection.createSpriteInstance("");
			addChild(_bg);
			
//			_text = new CustomTextfield();
		}
		
		private function update():void
		{
			
		}
		
		/**
		 * [继承] 恢复资源
		 * 
		 */		
		public override function resume():void
		{
			super.resume();
			
		}
		
		/**
		 * [继承] 释放资源
		 * 
		 */		
		public override function dispose():void
		{
			super.dispose();
			
		}

	}
}