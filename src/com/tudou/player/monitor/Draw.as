package com.tudou.player.monitor 
{
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	/**
	 * 绘制
	 * 
	 * @author 8088 at 2015/1/15 16:03:43
	 */
	public class Draw
	{
		internal var graphics:Graphics;
		internal static const MATRIX:Matrix = new Matrix();
		internal static const DRAW:Draw = new Draw(null);
		
        public function Draw(graphics:Graphics)
        {
            this.graphics = graphics;
        }
		
        public function fill(colors:*, alphas:* = null, ratios:Array = null, rotation:Number = 0, width:Number = 0, height:Number = 0, tx:Number = 0, ty:Number = 0, type:String = null):Draw
        {
            if (colors is Array)
            {
                if (alphas is Number)
                {
                    alphas = buildArray(colors.length, alphas, alphas);
                }
                else if (!(alphas is Array)) {
                    alphas = buildArray(colors.length, 1, 1);
                }
                ratios = ratios || buildArray(colors.length, 0, 0xFF, true);
                type = type || GradientType.LINEAR;
                MATRIX.createGradientBox(width, height, Math.PI / 180 * rotation, tx, ty);
                graphics.beginGradientFill(type, colors, alphas, ratios, MATRIX);
            }
            else if (colors is Number) {
                if (alphas == null)
                {
                    alphas = 1;
                }
                graphics.beginFill(colors, alphas);
            }
            return this;
        }
		
        public function rect(x:Number, y:Number, w:Number, h:Number):Draw
        {
            graphics.drawRect(x, y, w, h);
            return this;
        }
		
        protected function buildArray(length:int, min:Number, max:Number, b:Boolean = false):Array
        {
            if (length == 1)
            {
                return [min];
            }
            var ary:Array = [];
            var i:int;
            while (i < length)
            {
                if (b)
                {
                    ary[ary.length] = Math.floor(min + (max - min) / (length - 1) * i);
                }
                else {
                    ary[ary.length] = min + (max - min) / (length - 1) * i;
                }
                i++;
            }
            return ary;
        }
		
        public function clear():Draw
        {
            graphics.clear();
            return this;
        }
		
        public function curve(x:Number, y:Number, ...args):Draw
        {
            var _a:Number;
            var _b:Number;
            var _c:Number;
            var _x:Number = x;
            var _y:Number = y;
            graphics.moveTo(x, y);
            var i:int;
            while (i < args.length) {
                _a = args[i];
                _b = args[i + 1];
                _c = args[i + 2];
                graphics.curveTo(((_x + ((_a - _x) / 2)) + (((_b - _y) / 2) * _c)), ((_y + ((_b - _y) / 2)) - (((_a - _x) / 2) * _c)), _a, _b);
                _x = _a;
                _y = _b;
                i = (i + 3);
            };
            return this;
        }
		
        public function circle(x:Number, y:Number, r:Number):Draw
        {
            graphics.drawCircle(x, y, r);
            return this;
        }
		
        public function roundRect(x:Number, y:Number, w:Number, h:Number, e:Number):Draw
        {
            graphics.drawRoundRect(x, y, w, h, e);
            return this;
        }
		
        public function line(x:Number, y:Number, ...args):Draw
        {
            graphics.moveTo(x, y);
            var i:int;
            while (i < args.length)
            {
                graphics.lineTo(args[i], args[(i + 1)]);
                i = i + 2;
            }
            return this;
        }
		
        public function stroke(t:Number, l:* = null, a:* = null, r:Array = null, i:Number = 0, w:Number = 0, h:Number = 0, tx:Number = 0, ty:Number = 0, type:String = null):Draw
        {
            if (l is Array)
            {
                if (!(a is Array))
                {
                    a = null;
                }
                a = a || buildArray(l.length, 1, 1);
                r = r || buildArray(l.length, 0, 255, true);
                type = type || GradientType.LINEAR;
                MATRIX.createGradientBox(w, h, Math.PI / 180 * i, tx, ty);
                graphics.lineStyle(t);
                graphics.lineGradientStyle(type, l, a, r, MATRIX);
            }
            else if (l is Number) {
                if (a == null)
                {
                    a = 1;
                }
                graphics.lineStyle(t, l, a);
            }
            else {
                graphics.lineStyle(t);
            }
            return this;
        }
		
        public function bitmapFill(bmd:BitmapData, mtx:Matrix = null):Draw
        {
            graphics.beginBitmapFill(bmd, mtx);
            return this;
        }
		
        public function end():Draw
        {
            graphics.endFill();
            graphics.lineStyle();
            return this;
        }
		
        public static function invisibleRect(g:Graphics, x:Number, y:Number, w:Number, h:Number):void
        {
            g.clear();
            g.beginFill(0, 0);
            g.drawRect(x, y, w, h);
            g.endFill();
        }
		
	}
}