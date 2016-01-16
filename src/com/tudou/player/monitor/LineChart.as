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
	 * 线型图表
	 * 
	 * @author 8088 at 2015/1/15 16:05:59
	 */
	public class LineChart extends Sprite
	{
		private var data:Array;
		private var chart:Shape;
		private var _w:Number;
		private var _h:Number;
		private var _p:Number;
		private var _c:uint;
		private var _m:Matrix;
		
        private var line_colors:Array;
        private var line_alphas:Array;
        private var line_ratios:Array;
        private var fill_colors:Array;
        private var fill_alphas:Array;
        private var fill_ratios:Array;
		
		private var default_color:uint = 0xffffff;
        public function LineChart(x:Number=0, y:Number=0, w:Number=0, h:Number=0, pix:uint=2)
        {
            this.data = [];
			chart = new Shape();
			addChild(chart);
			
			this.x = x;
			this.y = y;
			_w = w;
			_h = h;
			_p = pix;
			_c = default_color;
			_m = new Matrix();
			
			line_colors = [default_color, default_color];
			line_alphas = [.35, 1];
			line_ratios = [210, 255];
			fill_colors = [default_color, default_color];
			fill_alphas = [.01, .8];
			fill_ratios = [0, 200];
			
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
			_w = w;
			_h = h;
            Draw.invisibleRect(this.graphics, 0, 0, w, h);
        }
		
        protected function redraw():void
        {
            var min:Number;
            var max:Number;
            var len:uint = data.length;
            var start:uint = Math.max(len - int(_w / _p), 0);
			var _g:Graphics = chart.graphics;
			
            min = Math.min.apply(null, data.slice(start));
            max = Math.max.apply(null, data.slice(start));
            var ypos:* = function (num:Number):Number
            {
                if (max == min)
                {
                    return _h;
                }
                var n:* = Math.min((num - min) / (max - min), 1);
                return _h - Math.floor(n * _h);
            };
            _g.clear();
            _g.moveTo(0, ypos(data[start]));
			_g.lineStyle(1, 0, 1, false, LineScaleMode.NONE, CapsStyle.NONE);
            _m.createGradientBox(_w, _h, 0, Math.min(_p * len - _w, 0));
            _g.lineGradientStyle(GradientType.LINEAR, line_colors, line_alphas, line_ratios, _m);
            _m.createGradientBox(1, _h, (-Math.PI) * 0.5);
            _g.beginGradientFill(GradientType.LINEAR, fill_colors, fill_alphas, fill_ratios, _m);
            var i:uint = start + 1;
            while (i < len)
            {
                _g.lineTo((i - start)*_p, ypos(data[i]));
                i = i + 1;
            }
			_g.lineStyle(0, 0, 0);
            _g.lineTo((i - 1 - start)*_p, _h);
            _g.lineTo(0, _h);
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
				fill_colors = [_c, _c];
				line_colors = [_c, default_color];
				redraw();
			}
		}
	}

}