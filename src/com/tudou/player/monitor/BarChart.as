package com.tudou.player.monitor 
{
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	/**
	 * 条型图表
	 * 
	 * @author 8088 at 2015/1/15 16:05:59
	 */
	public class BarChart extends Sprite
	{
		private var data:Array;
		private var chart:Shape;
		private var _a:Number;
		private var _w:Number;
		private var _h:Number;
		private var _p:Number;
		private var _c:uint;
		
		private var default_color:uint = 0xffffff;
        public function BarChart(x:Number=0, y:Number=0, w:Number=0, h:Number=0, pix:uint=2)
        {
            this.data = [];
			chart = new Shape();
			addChild(chart);
			
			this.x = x;
			this.y = y;
			_a = .8;
			_w = w;
			_h = h;
			_p = pix;
			_c = default_color
			
			setSize(_w, _h);
        }
		
        public function push(num:Number):void
        {
            data.push(num || 0);
            if (data.length > _w * 2)
            {
                data.splice(0, data.length - _w);
            }
            redraw();
        }
		
        public function setSize(w:Number, h:Number):void
        {
			if (_w != w || _h != h)
			{
				_w = w;
				_h = h;
				Draw.invisibleRect(this.graphics, 0, 0, w, h);
			}
        }
		
        protected function redraw():void
        {
            var min:Number;
            var max:Number;
            var len:uint = data.length;
            var start:uint = Math.max(len - int(_w / (_p+1)), 0);
			var _g:Graphics = chart.graphics;
			
            min = Math.min.apply(null, data.slice(start));
            max = Math.max.apply(null, data.slice(start));
            var ypos:* = function (num:Number):Number
            {
				var h:Number = 1;
                if (max == min) return h;
                var n:* = Math.min((num - min) / (max - min), 1);
				h = _h - Math.floor(n * _h);
                return h > 0?h:1;
            };
            _g.clear();
            var i:uint = start + 1;
            while (i < len)
            {
				var h:Number = -ypos(data[i]);
				_g.beginFill(_c, _a);
				_g.drawRect((i - start) * (_p+1), _h, _p, h);
                i = i + 1;
            }
			
        }
		
        public function get last():Number
        {
            return data[data.length - 1];
        }
		
		public function	get color():uint
		{
			return _c;
		}
		
		public function set color(value:uint):void
		{
			if (_c != value)
			{
				_c = value;
				redraw();
			}
		}
	}

}