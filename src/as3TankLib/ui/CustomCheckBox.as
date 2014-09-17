package as3TankLib.ui
{
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	
	/**
	 *自定义checkBox,封装checkbox相关方法
	 * @author Leo
	 *
	 */
	public class CustomCheckBox extends BaseSprite
	{
		/**
		 * 皮肤
		 */
		private var _skinStyle:uint = 1;
		
		/**
		 * 文本
		 */		
		private var textFeild:CustomTextfield;
		
		/**
		 * 是否有滤镜
		 */		
		private var isGlow:Boolean;
		
		/**
		 * 图标背景
		 */		
		private var icon:CustomImage;
		
		public function CustomCheckBox(_isGlow:Boolean = true)
		{
			super();
			isGlow = _isGlow;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			textFeild = new CustomTextfield(isGlow);
			textFeild.x = 26;
			if("" != _htmlText)
				textFeild.htmlText = _htmlText;
			if("" != text)
				textFeild.text = text;
			if(null != _size)
				textFeild.size = _size;
			textFeild.color = _color;
			textFeild.autoSize = TextFieldAutoSize.LEFT;
			addChild(textFeild);
			
			icon = new CustomImage(); //默认加载未选中素材
			icon.load("CheckBox_upIcon" + _skinStyle);
			addChild(icon);
			
			buttonMode = true;
			useHandCursor = true;
			
		}
		
		protected function onMouseUpHandler(event:MouseEvent):void
		{
			selected = !selected;
			if(selected)
				icon.load("CheckBox_selectedOverIcon" + _skinStyle);
			else
				icon.load("CheckBox_overIcon" + _skinStyle);
		}
		
		protected function onMouseOverHandler(event:MouseEvent):void
		{
			if(selected)
				icon.load("CheckBox_selectedOverIcon" + _skinStyle);
			else
				icon.load("CheckBox_overIcon" + _skinStyle);
		}
		
		protected function onMouseOutHandler(event:MouseEvent):void
		{
			if(selected)
				icon.load("CheckBox_selectedUpIcon" + _skinStyle);
			else
				icon.load("CheckBox_upIcon" + _skinStyle);
		}		
		
		private var _selected:Boolean = false;
		/**
		 * 是否选中
		 */
		public function get selected():Boolean
		{
			return _selected;
		}
		/**
		 * @private
		 */
		public function set selected(value:Boolean):void
		{
			if(_selected == value)
				return;
			_selected = value;
			if(_selected)
				icon.load("CheckBox_selectedUpIcon" + _skinStyle);
			else
				icon.load("CheckBox_upIcon" + _skinStyle);
		}
		
		private var text:String = "";
		/**
		 * 文字内容
		 */
		public function get label():String
		{
			if(initialized)
				return textFeild.text;
			else
				return text;
		}
		/**
		 * @private
		 */
		public function set label(value:String):void
		{
			_htmlText = value;
			if(initialized)
				textFeild.htmlText = _htmlText;
		}
		
		private var _htmlText:String = "";
		/**
		 * 设置文本html内容
		 */
		public function get htmlText():String
		{
			if(initialized)
				return textFeild.htmlText;
			else
				return _htmlText;
		}
		
		/**
		 * @private
		 */
		public function set htmlText(value:String):void
		{
			text = "";
			_htmlText = value;
			if(initialized)
				textFeild.htmlText = value;
		}
		
		private var _color:uint = 0xffffff;
		/**
		 * 字体颜色
		 * @param value
		 *
		 */
		public function set color(value:uint):void
		{
			_color= value;
			if(initialized)
				textFeild.color = _color;
		}
		
		private var _size:Object = null;
		/**
		 * 字体大小
		 * @param value
		 *
		 */
		public function set size(value:Object):void
		{
			_size = value;
			if(initialized)
				textFeild.size = _size;
		}
		
		/**
		 * 按钮样式
		 * @param style 选择第几种样式,0为默认皮肤
		 *
		 */
		
		public function set skinStyle(style:int):void
		{
			_skinStyle = style;
		}
		
		public override function resume():void
		{
			super.resume();
			
			addEventListener(MouseEvent.MOUSE_UP , onMouseUpHandler);
			addEventListener(MouseEvent.MOUSE_OVER , onMouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT , onMouseOutHandler);
		}
		
		/**
		 * 销毁对象资源
		 *
		 */
		public override function dispose():void
		{
			super.dispose();
			
			removeEventListener(MouseEvent.MOUSE_UP , onMouseUpHandler);
			removeEventListener(MouseEvent.MOUSE_OVER , onMouseOverHandler);
			removeEventListener(MouseEvent.MOUSE_OUT , onMouseOutHandler);
		}
	}
}



