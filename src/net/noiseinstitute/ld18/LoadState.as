package net.noiseinstitute.ld18
{
	import org.flixel.*;
	
	public class LoadState extends FlxState {
		
		public static const FIXED:FlxPoint = new FlxPoint(0,0);
		private static const TOTAL_PROGRESS:Number = 7;
		
		private var progress:Number;
		private var progressBar:FlxText;
		
		override public function create():void {
			Game.sound = new Sound();
			progress = -1;
			
			var loadingMsg:FlxText = new FlxText(0, (FlxG.height / 2) - 15, FlxG.width);
			loadingMsg.text = "Loading"
			loadingMsg.color = 0xffffff;
			loadingMsg.size = 24;
			loadingMsg.alignment = "center";
			loadingMsg.scrollFactor = FIXED;
			loadingMsg.shadow = 0x333333;
			add(loadingMsg);

			progressBar = new FlxText(0, (FlxG.height / 2) + 15, FlxG.width);
			var strPrg:String = "[";
			for(var i:Number = 0; i < TOTAL_PROGRESS; i++) strPrg = strPrg + " "
			progressBar.text = strPrg + "]"
			progressBar.color = 0xffffff;
			progressBar.size = 24;
			progressBar.alignment = "center";
			progressBar.scrollFactor = FIXED;
			add(progressBar);
		}
		
		override public function update():void {
			if(progress >= 0 && Game.sound.loadNext()) {
				super.update();
				FlxG.state = new TitleState();
			} else {
				progress++;
				var strPrg:String = "[";
				for(var i:Number = 0; i < Math.min(progress, TOTAL_PROGRESS); i++) strPrg = strPrg + "-";
				for(var j:Number = progress; j < TOTAL_PROGRESS; j++) strPrg = strPrg + " ";
				progressBar.text = strPrg + "]";
			}
			super.update();
		}
	}
}