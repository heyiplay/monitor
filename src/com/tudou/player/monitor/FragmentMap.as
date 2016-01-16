package com.tudou.player.monitor 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * 碎片图
	 * 
	 * @author 8088 at 2015/1/15 16:15:51
	 */
	public class FragmentMap extends Sprite
	{
		private var _data:Array;
        private var _max:int;
		
		private var background:Shape;
		
		private var _w:Number = 0;
		private var _h:Number = 0;

        public function FragmentMap()
        {
            _data = [];
			background = new Shape();
        }
		
        public function setSize(w:Number, h:Number):void
        {
			_w = w;
			_h = h;
            Draw.invisibleRect(background.graphics, 0, 0, w, h);
        }
		
        protected function drawBackground():void
        {
            drawing(background.graphics).clear().fill(0xffffff, 0.1).rect(0, 0, _w, _h).end();
        }

        public function set data(value:Array):void
        {
            _data = value;
            redraw();
        }
		
        protected function redraw() : void
        {
            var shape:Shape;
            var point:Point;
            background.graphics.clear();
            if (!_max) return;
            var i:int = numChildren - 1;
            while (i >= 0) {
                if (getChildAt(i) is Shape){
                    removeChildAt(i);
                };
                i--;
            };
            var r:Number = _w / _max;
            for each (var interval:Object in _data) {
                shape = new Shape();
				drawing(shape.graphics).stroke(0, 0, 0.5).fill(0xFFFFFF).rect(0, 0, 1, 1).end();
                point = localToGlobal(new Point(Math.ceil((interval.start * r)), 0));
                while (hitTestPoint((point.x + 1), (point.y + 1), true)) {
                    point.y = (point.y + (_h + 1));
                };
                point = globalToLocal(point);
                shape.x = point.x;
                shape.y = point.y;
                shape.width = Math.floor(interval.end * r - shape.x) || 1;
                shape.height = _h;
                addChild(shape);
            };
            drawBackground();
        }
		
        public function set max(value:int):void
        {
            if (_max != value)
            {
				_max= value;
                redraw();
            }
        }
		
		public function get max():int
        {
            return _max;
        }
		
        public function get data():Array
        {
            return _data;
        }
		
    }
}
