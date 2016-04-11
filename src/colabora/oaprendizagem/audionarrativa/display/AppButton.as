package colabora.oaprendizagem.audionarrativa.display 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class AppButton extends Sprite
	{
		
		public var cliqueF:Function;
		
		public function AppButton(gr:Bitmap, cl:Function) 
		{
			this.cliqueF = cl;
			this.addChild(gr);
			this.addEventListener(MouseEvent.CLICK, clique);
		}
		
		private function clique(evt:MouseEvent):void
		{
			this.cliqueF();
		}
		
	}

}