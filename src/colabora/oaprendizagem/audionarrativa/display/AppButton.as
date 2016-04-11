package colabora.oaprendizagem.audionarrativa.display 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class AppButton extends Sprite
	{
		
		public var cliqueF:Function;
		public var repetir:Boolean;
		
		private var _intervalo:int = -1;
		private var _repetindo:Boolean = false;
		
		public function AppButton(gr:Bitmap, cl:Function, rp:Boolean = true) 
		{
			this.cliqueF = cl;
			this.repetir = rp;
			this.addChild(gr);
			this.addEventListener(MouseEvent.CLICK, clique);
			if (rp) {
				this.addEventListener(MouseEvent.MOUSE_DOWN, comecaToque);
			}
		}
		
		public function fimToque():void
		{
			try { clearInterval(this._intervalo); } catch (e:Error) { }
			this._intervalo = -1;
		}
		
		private function repeticao():void
		{
			this._repetindo = true;
			this.cliqueF();
		}
		
		private function clique(evt:MouseEvent):void
		{
			if (!this._repetindo) this.cliqueF();
			this._repetindo = false;
		}
		
		private function comecaToque(evt:MouseEvent):void
		{
			this._repetindo = false;
			if (this.repetir) {
				this._intervalo = setInterval(this.repeticao, 1000);
			}
		}
		
	}

}