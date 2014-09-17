package as3TankLib.ui
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import as3TankLib.util.Reflection;
	
	import fl.controls.Button;
	
	[Event(name = "complete", type = "flash.events.Event")]
	/**
	 *  通用按钮<br/>
	 *  通过skinStyle可以设置皮肤
	 */
	public class CustomButton extends Button implements IReleaseable
	{
		/**
		 * 滤镜数组
		 */
		private var _filterArray:Array;
		/**
		 * 文本格式设置对象
		 */
		private var _textFormat:TextFormat;
		/**
		 * 发光滤镜
		 */
		private var _glowFilter:GlowFilter;
		/**
		 * 按钮样式
		 */
		private var _skinStyle:int = 1;
		
		/**
		 * 文本相对按钮顶部的Y坐标
		 * 
		 */		
		public var txtHeightGap:int = -2;//偏离的文本高度
		
		public function CustomButton()
		{
			super();
			
			buttonMode = true;
			useHandCursor = true;
			_textFormat = new TextFormat();
			_textFormat.align = TextFormatAlign.CENTER;
			_textFormat.color = 0xffffff;
//			_textFormat.font = CustomTextfield.fontStyle;
			_textFormat.size = 12;
			clearStyle("textFormat");
			setStyle("textFormat", _textFormat);
			setStyle("disabledTextFormat", _textFormat);
			super.textField.autoSize = TextFieldAutoSize.LEFT;
			_glowFilter = new GlowFilter(0x0, 1, 2, 2,3);
			_filterArray = [_glowFilter];
			textField.filters = filters;
			textBorderColor = 0;
			doSetSkinStyle(_skinStyle);
			width =  78; //默认按钮的宽高
			skinStyle = _skinStyle;
		}
		
		/**
		 * 按钮样式（1-10普通按钮，11及以上为tabbar按钮皮肤，具体看uicomponen.fla）
		 * @param style 选择第几种样式,1为默认皮肤
		 *
		 */
		public function set skinStyle(style:int):void
		{
			_skinStyle = style;
			if(height == 0)//高度还未设定
			{
				if(_skinStyle == 3)
				{
					height = 24;
				}
				else
				{
					height = 30;
				}
			}
			doSetSkinStyle(_skinStyle);
		}
		
		/**
		 * 加载完对应的组件资源后处理
		 * @param evt
		 *
		 */
		private function doSetSkinStyle(valSkin:int):void
		{
			clearStyle("upSkin");
			clearStyle("overSkin");
			clearStyle("disableSkin");
			clearStyle("downSkin");
			clearStyle("selectedOverSkin");
			clearStyle("selectedUpSkin");
			clearStyle("selectedDownSkin");
			
			var upSkin:Sprite = Reflection.createInstance("Button_UpSkin" + valSkin);
			var selectedUpSkin:Sprite =  Reflection.createInstance("Button_SelectedUpSkin" + valSkin);
			var overSkin:Sprite = Reflection.createInstance("Button_OverSkin" +valSkin);
			var selectedOverSkin:Sprite =  Reflection.createInstance("Button_SelectedOverSkin" + valSkin);
			var downSkin:Sprite =  Reflection.createInstance("Button_DownSkin" + valSkin); //选中的时候
			var selectedDownSkin:Sprite = Reflection.createInstance("Button_SelectedDownSkin" +valSkin); //选中的时候
			var disableSkin:Sprite =  Reflection.createInstance("Button_DisableSkin" + valSkin);
			
			
			setStyle("upSkin", upSkin);
			
			if (overSkin != null)
			{
				setStyle("overSkin", overSkin);
			}
			else
			{
				setStyle("overSkin", upSkin);
			}
			
			if (downSkin != null)
			{
				setStyle("downSkin", downSkin);
			}
			else
			{
				setStyle("downSkin", upSkin);
			}
			if (disableSkin != null)
			{
				setStyle("disabledSkin", disableSkin);
			}
			else
			{
				setStyle("disabledSkin", upSkin);
			}
			if (selectedUpSkin == null)
			{ //无选中状态皮肤的按钮
				setStyle("selectedUpSkin", downSkin);
				setStyle("selectedOverSkin", downSkin);
				if (downSkin != null)
				{
					setStyle("selectedDownSkin", downSkin);
				}
			}
			else
			{
				setStyle("selectedUpSkin", selectedUpSkin);
				if(selectedOverSkin != null){
					setStyle("selectedOverSkin", selectedOverSkin);
				}else{
					setStyle("selectedOverSkin", selectedUpSkin);
				}
				
				if (selectedDownSkin != null)
				{
					setStyle("selectedDownSkin", selectedDownSkin);
				}
				else
				{
					setStyle("selectedDownSkin", selectedUpSkin);
				}
			}
		}
		
		
		override protected function drawLayout():void{
			super.drawLayout();
			if(txtHeightGap!=0){
				textField.y += txtHeightGap;
			}
		}
		
		public function get skinStyle():int
		{
			return _skinStyle;
		}
		
		override protected function draw():void
		{
			try
			{
				super.draw();
			}
			catch (e:Error)
			{
			}
		}
		
		/**
		 * 设置对其方式
		 * @param value
		 *
		 */
		public function set align(value:String):void
		{
			_textFormat.align = value;
			setStyle("textFormat", _textFormat);
			
		}
		
		/**
		 * 指定文本是否为粗体字。默认值为 null，这意味着不使用粗体字。如果值为 true，则文本为粗体字。
		 * @param value
		 *
		 */
		public function set bold(value:Object):void
		{
			_textFormat.bold = value;
			setStyle("textFormat", _textFormat);
		}
		/**
		 * 指示文本的颜色。
		 * 包含三个 8 位 RGB 颜色成分的数字；例如，0xFF0000 为红色，0x00FF00 为绿色。默认值为 null，这意味着 Flash Player 使用黑色 (0x000000)。
		 * @param value
		 *
		 */
		private var _color:Object = 0x000000;
		
		public function set color(value:Object):void
		{
			_textFormat.color = value;
			_color = value;
			setStyle("textFormat", _textFormat);
		}
		
		public function get color():Object
		{
			return _color;
		}
		
		/**
		 * 指示文本选中的颜色。
		 * 包含三个 8 位 RGB 颜色成分的数字；例如，0xFF0000 为红色，0x00FF00 为绿色。默认值为 null，这意味着 Flash Player 使用黑色 (0x000000)。
		 * @param value
		 *
		 */
		private var _selectedColor:Object = 0x000000;
		
		public function set selectedColor(value:Object):void
		{
			_selectedColor = value;
		}
		
		/**
		 * 使用此文本格式的文本的字体名称，以字符串形式表示。默认值为 null，这意味着 Flash Player 对文本使用 Times New Roman 字体
		 * @param value
		 *
		 */
		public function set font(value:String):void
		{
			_textFormat.font = value;
			setStyle("textFormat", _textFormat);
		}
		
		/**
		 * 使用此文本格式的文本的磅值。默认值为 null，这意味着使用的磅值为 12
		 * @param value
		 *
		 */
		public function set size(value:Object):void
		{
			_textFormat.size = value;
			setStyle("textFormat", _textFormat);
		}
		
		/**
		 * 设置是否在选择状态
		 * @param value
		 *
		 */
		override public function set selected(value:Boolean):void
		{
			if (value)
			{
				if (!toggle)
					toggle = true;
				if (_selectedColor != 0x000000)
					color = _selectedColor;
			}
			else
			{
				color = _color;
			}
			super.selected = value;
		}
		
		/**
		 * 设置字体边缘的颜色
		 * @param value
		 *
		 */
		public function set textBorderColor(value:uint):void
		{
			_glowFilter.color = value;
			textField.filters = _filterArray;
			
		}
		
		/**
		 * 设置边缘的透明度
		 * @param value
		 *
		 */
		public function set textBorderAlpha(value:Number):void
		{
			_glowFilter.alpha = value;
			textField.filters = _filterArray;
			
		}
		
		/**
		 * 设置字体边缘X方向模糊度
		 * @param value
		 *
		 */
		public function set textBorderBlurX(value:Number):void
		{
			_glowFilter.blurX = value;
			textField.filters = _filterArray;
		}
		
		/**
		 * 设置字体边缘Y方向的模糊度
		 * @param value
		 *
		 */
		public function set textBorderBlurY(value:Number):void
		{
			_glowFilter.blurY = value;
			textField.filters = _filterArray;
		}
		
		/**
		 * 印记或跨页的强度。
		 * 该值越高，压印的颜色越深，而且发光与背景之间的对比度也越强。有效值为 0 到 255。默认值为 2。
		 * @param value
		 *
		 */
		public function set textBorderStrength(value:Number):void
		{
			_glowFilter.strength = value;
			textField.filters = _filterArray;
		}
		
		private static var enableFilter:Array;
		
		override public function set enabled(arg0:Boolean):void
		{
			if (super.enabled == arg0)
				return;
			super.enabled = arg0;
			if (arg0)
			{
				this.useHandCursor = true;
				filters = null;
			}
			else
			{
				this.useHandCursor = false;
				if (enableFilter == null)
				{
					var myarr:Array=[0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0];
					var colorFilter:ColorMatrixFilter = new ColorMatrixFilter(myarr);
					enableFilter = [colorFilter];
				}
				filters = enableFilter;
			}
		}
		
		/**
		 * 重写focuse方法
		 * @param arg0
		 */
		override public function drawFocus(arg0:Boolean):void
		{
			
		}
		
		public function set filterArray(value:Array):void
		{
			_filterArray = value;
			textField.filters = _filterArray;
		}
		
		private var _labelImg:Bitmap;
		private var _labelImgXsite:int;
		private var _labelImgYsite:int;
		private var _labelImgCenter:int;
		
		/**
		 * 备份图片文本名字，资源释放和恢复时用 
		 */		
		private var backupLabelIcon:String = "";
		/**
		 * 设置图片文本 
		 * @param name
		 * 
		 */		
		public function setLabelPhoto(name:String=null,xSite:int=0,ySite:int=0):void
		{
			clearStyle("icon");
			_labelImgXsite = xSite;
			_labelImgYsite = ySite;
			if (ApplicationDomain.currentDomain.hasDefinition(name))
			{//优先从当前域里面取bitmapdata
				if (_labelImg == null)
				{
					_labelImg = new Bitmap();
				}
				backupLabelIcon = name;
				_labelImg.bitmapData = Reflection.createBitmapDataInstance(name);
				onImgComplt();
			}
		}
		
		/**
		 * 设置图标 
		 * 
		 */		
		protected function onImgComplt():void
		{
			super.label = "";
			
			if(_labelImgXsite == 0 && _labelImgYsite == 0)
			{
				setStyle("icon", _labelImg);
				this.drawIcon();
			}
			else
			{   
				//设置文字图标位置
				addChild(_labelImg);
				
				_labelImg.x = _labelImgXsite;
				_labelImg.y = _labelImgYsite;
				
			}
		}
		
		/**
		 * 移除图标 
		 * 
		 */		
		public function removeLabelImg():void
		{
			if (_labelImg && _labelImg.parent)
				_labelImg.parent.removeChild(_labelImg);
			_labelImg = null;
		}
		/**
		 * 构建按钮
		 * @param posx
		 * @param posy
		 * @param label
		 * @return 
		 * 
		 */
		public static function buildCustomBtn(posx:int, posy:int, w:int, h:int, scale:Rectangle, style:int):CustomButton {
			var btn:CustomButton = new CustomButton();
			btn.scale9Grid = scale;
			btn.width = w;
			btn.height = h;
			btn.skinStyle = style;
			btn.x = posx;
			btn.y = posy;
			return btn;
		}
		
		/**
		 * 恢复资源 
		 * 
		 */		
		public function resume():void
		{
			textField.filters = _filterArray;
			if(_labelImg)
				_labelImg.bitmapData = Reflection.createBitmapDataInstance(backupLabelIcon);
		}
		
		/**
		 * 释放资源 
		 * 
		 */		
		public function dispose():void
		{
			textField.filters = [];
			if(_labelImg)
				_labelImg.bitmapData = null;
		}
	}
}


