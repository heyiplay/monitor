package com.tudou.player.monitor 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.utils.getTimer;
	/**
	 * 像素图表
	 * 
	 * @author 8088 at 2015/1/15 16:05:59
	 */
	public class PixelMap extends Sprite
	{
		private var map:Bitmap;
		private var _w:Number;
		private var _h:Number;
		private var _i:uint;
		
		private var default_color:uint = 0xffffff;
        public function PixelMap(x:Number=0, y:Number=0, w:Number=0, h:Number=0)
        {
			this.x = x;
			this.y = y;
			_w = w;
			_h = h;
			_i = 0;
            
			if (w > 0 && h > 0) setSize(w, h);
			
        }
		
        public function setSize(w:Number, h:Number):void
        {
			_w = w;
			_h = h;
            
			var bmd:BitmapData = new BitmapData(_w, _h, true, 0);
			if (map == null)
			{
				map = new Bitmap(bmd);
				addChild(map);
			}
			else {
				map.bitmapData.dispose();
				map.bitmapData = bmd;
			}
        }
		
		public function update(items:Array):void
		{
			if (items && items.length > 0)
			{
				var _x:uint = _i;
				if (_i >= _w)
				{
					_x = _w - 1;
					map.bitmapData.scroll(-1, 0);
				}
				map.bitmapData.fillRect(new Rectangle(_x, 0, 1, _h), 0);
				var ln:int = items.length;
				for (var i:int = 0; i != ln; i++)
				{
					map.bitmapData.setPixel32(_x, items[i].y, items[i].color);
				}
				if(_i<_w) _i++;
			}
		}
		
		
	}

}