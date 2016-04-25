package colabora.oaprendizagem.audionarrativa.display 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class JanelaIncluiAudio extends JanelaEscolha
	{
		
		// VARIÁVEIS PRIVADAS
		
		private var _biblioteca:Sprite;
		private var _meusaudios:Sprite;
		
		public function JanelaIncluiAudio(w:Number, h:Number) 
		{
			super(w, h, 'Incluir áudio a partir de');
			
			this._biblioteca = Main.graficos.getSPGR('BTBiblioteca');
			this._meusaudios = Main.graficos.getSPGR('BTMeusAudios');
			
			var intervalo:Number = (this._bg.width - this._biblioteca.width - this._meusaudios.width) / 3;
			this._biblioteca.x = this._bg.x + intervalo;
			this._meusaudios.x = this._biblioteca.x + this._biblioteca.width + intervalo;
			this._biblioteca.y = this._bg.y + this._bg.height - 50 - this._biblioteca.height;
			this._meusaudios.y = this._bg.y + this._bg.height - 50 - this._meusaudios.height;
			
			this.addChild(this._biblioteca);
			this.addChild(this._meusaudios);
			
			this._biblioteca.addEventListener(MouseEvent.CLICK, onBiblioteca);
			this._meusaudios.addEventListener(MouseEvent.CLICK, onMeusAudios);
		}
		
		// FUNÇÕES PRIVADAS
		
		/**
		 * Clique no botão biblioteca.
		 */
		private function onBiblioteca(evt:MouseEvent):void
		{
			parent.removeChild(this);
			this.dispatchEvent(new Event('biblioteca'));
		}
		
		/**
		 * Clique no botão meu áudios.
		 */
		private function onMeusAudios(evt:MouseEvent):void
		{
			parent.removeChild(this);
			this.dispatchEvent(new Event('meusaudios'));
		}
		
	}

}