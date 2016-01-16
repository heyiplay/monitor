package com.tudou.player.monitor 
{
	import com.tudou.layout.LayoutSprite;
	import com.tudou.ui.ShortcutKeys;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	/**
	 * 播放信息监控器
	 * 
	 * @author 8088 at 2015/1/15 15:44:10
	 */
	public class PlayInfoMonitor extends LayoutSprite
	{
        private var runMap:PixelMap;
        private var netChart:LineChart;
		
		private var fps:TextField;
		private var mem:TextField;
		private var tcp:TextField;
		private var udp:TextField;
		private var net:TextField;
		private var txt:TextField;
		private var close_btn:CloseButton;
        private static const BLUE:uint = 0x0099FF;
        private static const GREEN:uint = 0x99CC33;
		private static const SHORTCUT_CODE:String = "PlayInfoMonitor.Start.Up";
		private const DEFAULT_STYLE:String = "position:stage; top:20; left:20; width:280; height:175; background:#99000000; visible:false;"

		public function PlayInfoMonitor() 
		{
			super();
			
			style = DEFAULT_STYLE;
			
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			
			close_btn = new CloseButton(this.width-22, 2, 20, 20);
			close_btn.addEventListener(MouseEvent.CLICK, onClick);
			addChild(close_btn);
			
			var en_format:TextFormat = new TextFormat();
			en_format.font = "Arial";
			en_format.size = 11;
			
			var cn_format:TextFormat = new TextFormat();
			cn_format.font = "宋体";
			cn_format.size = 12;
			
			var ttl1:TextField = getStaticText(5, 4, 200, 20, cn_format);
			ttl1.text = "运行参考指标监控";
			addChild(ttl1);
			
			fps = getStaticText(5, 23, 100, 20, en_format, BLUE);
			fps.text = "FPS: ";
			addChild(fps);
			
			mem = getStaticText(5, 42, 100, 20, en_format, GREEN);
			mem.text = "MEM: ";
			addChild(mem);
			
			runMap = new PixelMap(104, 29, 158, 28);
			addChild(runMap);
			
			var ttl2:TextField = getStaticText(5, 62, 200, 20, cn_format);
			ttl2.text = "网络数据监控";
			addChild(ttl2);
			
			tcp = getStaticText(5, 81, 100, 20, en_format, BLUE);
			tcp.text = "TCP: ";
			addChild(tcp);
			
			udp = getStaticText(5, 100, 100, 20, en_format, GREEN);
			udp.text = "UDP: ";
			addChild(udp);
			
			netChart = new LineChart(104, 86, 158, 28);
			addChild(netChart);
			
			net = getStaticText(netChart.x, 81, netChart.width, 20, en_format);
			net.autoSize = TextFieldAutoSize.RIGHT;
			addChild(net);
			
			var ttl3:TextField = getStaticText(5, 120, 200, 20, cn_format);
			ttl3.text = "播放属性监控";
			addChild(ttl3);
			
			txt = getStaticText(5, 139, 270, 40, en_format);
			txt.multiline = true;
			txt.wordWrap = true;
			addChild(txt);
			
			//注册快捷键, 播放信息监控器对用户来说作用不大，所以隐藏在快捷键中呼出。
			var shortcuts:ShortcutKeys = ShortcutKeys.getInstance(this.stage);
			shortcuts.add("Ctrl+Alt+I", SHORTCUT_CODE, "播放信息监控");
			shortcuts.addEventListener(NetStatusEvent.NET_STATUS, onSatus);
			
		}
		
		override public function applyStyle():void
		{
			super.applyStyle();
			
			if (close_btn) close_btn.x = this.width - 22;
			
		}
		
		private var dataLoadProtocolType:String = "tcp";
        public function update(info:Object):void
        {
            if (visible)
			{
				dataLoadProtocolType = info.loadInfo.protocolType;
				if (dataLoadProtocolType == "udp") netChart.color = GREEN;
				else if(dataLoadProtocolType == "tcp") netChart.color = BLUE;
				
				tcp.text = "TCP: " + bytesToString(info.loadInfo.tcp.bytesLoaded);
				udp.text = "UDP: " + bytesToString(info.loadInfo.udp.bytesLoaded);
				if (info.loadInfo.oneSecondLoadByte != undefined)
				{
					netChart.push(info.loadInfo.oneSecondLoadByte);
					net.text = bytesToString(info.loadInfo.oneSecondLoadByte) + "/s";
				}
				
				txt.text = info.videoWidth + "x" + info.videoHeight + ", " 
					+ info.streamType + ", "
					+ info.rendering + " rendering, "
					+ info.decoding + " decoding, "
					//+ info.streamBitrate + " kbps, "
					+ info.volume + "% volume, "
					+ info.videoFps + " video fps"
					//+ "timestamp seconds " + info.timestamp
				;
			}
        }
		
		
		// Internals..
		//
		private function onSatus(evt:NetStatusEvent):void
		{
			switch(evt.info.code)
			{
				case SHORTCUT_CODE:
					start();
					break;
			}
		}
		
		private function getStaticText(x:Number, y:Number, w:Number, h:Number, format:TextFormat=null, color:uint=0xeeeeee):TextField
		{
			var txt:TextField = new TextField(); 
				txt.selectable = false;
				txt.textColor = color;
				txt.x = x;
				txt.y = y;
				txt.width = w;
				txt.height = h;
			if(format) txt.defaultTextFormat = format;
			//..
			return txt;
		}
		
		private function onClick(evt:MouseEvent):void
		{
			close();
		}
		
		private function start():void
		{
			if (!this.visible) this.visible = true;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			fpst = getTimer();
			
			
		}
		
		private function close():void
		{
			if (this.visible) this.visible = false;
			
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
		}
		
		private var delay:int;
		private var ft:int;
		private var fpst:int;
		private var mem_max:uint = 4.1943e+007;
		private function onEnterFrame(param1:Event) : void
        {
            var frame_rate:Number = 1000 / (getTimer() - fpst);
			var fps_rate:Number = frame_rate > stage.frameRate ? 1 : (frame_rate / stage.frameRate);
			mem_max = mem_max > System.totalMemory? mem_max:System.totalMemory;
			var mem_rate:Number = System.totalMemory / mem_max;
			var _fps:Object = { y:runMap.height * (1 - fps_rate), color:0xff0099FF };
			var _mem:Object = { y:runMap.height * (1 - mem_rate), color:0xff99CC33 };
			delay++;
            if (delay >= 10)
            {
                delay = 0;
				fps.text = "FPS: " + Number(1000 * 10 / (getTimer() - ft)).toFixed(2);
                ft = getTimer();
            }
			fpst = getTimer();
			mem.text = "MEM: " + bytesToString(System.totalMemory);
			runMap.update([_fps, _mem]);
        }
		
		private function bytesToString(value:uint):String
        {
            var str:String;
            if (value < 1024)
            {
                str = String(value) + "b";
            }
            else if (value < 10240) {
                str = Number(value / 1024).toFixed(2) + "kb";
            }
            else if (value < 102400) {
                str = Number(value / 1024).toFixed(1) + "kb";
            }
            else if (value < 1048576) {
                str = Math.round(value / 1024) + "kb";
            }
            else if (value < 10485760) {
                str = Number(value / 1048576).toFixed(2) + "mb";
            }
            else if (value < 104857600) {
                str = Number(value / 1048576).toFixed(1) + "mb";
            }
            else if (value < 1073741824){
                str = Math.round(value / 1048576) + "mb";
            }
            else if (value < 10737418240) {
                str = Number(value / 1073741824).toFixed(2) + "gb";
            }
            else if (value < 107374182400) {
                str = Number(value / 1073741824).toFixed(1) + "gb";
            }
            else if (value < 1099511627776){
                str = Math.round(value / 1073741824) + "gb";
            }
            return str;
        }
		
	}
}
import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.geom.Matrix;

class CloseButton extends Sprite
{
	public function CloseButton(x:Number, y:Number, w:Number, h:Number)
	{
		this.x = x;
		this.y = y;
		var btn:SimpleButton = new SimpleButton();
		btn.downState      = draw(w, h, 0xff6600);
		btn.overState      = draw(w, h, 0xff9933);
		btn.upState        = draw(w, h, 0xcccccc);
		btn.hitTestState   = draw(w, h, 0xff0000);
		btn.useHandCursor  = true;
		addChild(btn);
	}
	
	private function draw(w:uint, h:uint, c:uint):Shape
	{
		var s:Shape = new Shape();
		var g:Graphics = s.graphics;
		g.clear();
		var gradientBoxMatrix:Matrix = new Matrix();   
		g.beginFill(0, 0);
		g.drawRect(0, 0, w, h);
		g.endFill();
		//
		var _w:uint = int(w * .5);
		var _h:uint = int(h * .5);
		var _x:uint = int((w - _w) * .5);
		var _y:uint = int((h - _h) * .5);
		
		g.lineStyle(1, c);
		g.moveTo(_x, _y);
		g.lineTo(_x+_w, _y+_h);
		g.endFill();
		
		g.lineStyle(1, c);
		g.moveTo(_x+_w, _y);
		g.lineTo(_x, _y+_h);
		g.endFill();
		return s;
	}
}