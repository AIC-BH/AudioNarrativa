package colabora.oaprendizagem.audionarrativa.display 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class AreaVazia extends Sprite
	{
		/**
		 * Trilha representada nesta área.
		 */
		public var trilha:int = -1;
		
		/**
		 * Tempo referente a esta área.
		 */
		public var tempo:int = -1;
		
		// VARIÁVEIS PRIVADAS
		
		private var _bg:Bitmap;			// imagem de fundo
		
		public function AreaVazia(tr:int, tp:int) 
		{
			// preparando o fundo
			this._bg = Main.graficos.getGR('AreaVazia');
			this.addChild(this._bg);
			// informações
			this.trilha = tr;
			this.tempo = tp;
			// preparando para clique
			this.mouseChildren = false;
		}
		
		// FUNÇÕES PÚBLICAS
		
		/**
		 * Libera recursos usados por este objeto.
		 */
		public function dispose():void
		{
			this.removeChildren();
			this._bg.bitmapData.dispose();
			this._bg = null;
		}
		
		// FUNÇÕES PRIVADAS
		

	}

}