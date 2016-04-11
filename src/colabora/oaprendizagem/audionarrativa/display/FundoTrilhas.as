package colabora.oaprendizagem.audionarrativa.display 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class FundoTrilhas extends Sprite
	{
		
		private var _bg:Bitmap;
		private var _nums:Vector.<TextField>;
		
		public function FundoTrilhas() 
		{
			this._bg = Main.graficos.getGR('FundoTrilhas');
			this.addChild(this._bg);
			
			this._nums = new Vector.<TextField>();
			for (var i:int = 0; i < int(AreaApp.AREAWIDTH / AreaApp.BOXSIDE); i++) {
				var txt:TextField = new TextField();
				txt.width = AreaApp.BOXSIDE;
				txt.height = AreaApp.BOXSIDE / 2;
				txt.defaultTextFormat = new TextFormat('_sans', 35, 0xFFFFFF, true, null, null, null, null, 'center');
				txt.x = AreaApp.BOXSIDE * i;
				txt.y = AreaApp.BOXSIDE / 20;
				txt.selectable = false;
				this.addChild(txt);
				this._nums.push(txt);
			}
			
			this.mouseChildren = false;
		}
		
		public function setNum(inicio:int):void
		{
			for (var i:int = 0; i < this._nums.length; i++) {
				if ((inicio + i) < 0) {
					this._nums[i].text = '';
				} else {
					this._nums[i].text = String(inicio + i);
				}
			}
		}
		
	}

}