package com.tudou.player.monitor 
{
	import flash.display.*;
	/**
	 * ...
	 * @author 8088 at 2015/1/15 19:17:55
	 */
	public function drawing(graphics:Graphics):Draw
	{
		Draw.DRAW.graphics = graphics;
        return Draw.DRAW;
	}
}
