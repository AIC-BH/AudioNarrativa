package colabora.oaprendizagem.audionarrativa.display 
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class JanelaEscolha extends Sprite
	{
		
		// VARIÁVEIS PRIVADAS
		
		protected var _courtain:Shape;
		protected var _bg:Bitmap;
		protected var _fechar:Sprite;
		protected var _texto:TextField;
		
		public function JanelaEscolha(w:Number, h:Number, tx:String, fechar:Boolean = true) 
		{
			// cortina
			this._courtain = new Shape();
			this._courtain.graphics.beginFill(0, 0.8);
			this._courtain.graphics.drawRect(0, 0, w, h);
			this._courtain.graphics.endFill();
			this.addChild(this._courtain);
			
			// janela
			this._bg = Main.graficos.getGR('FundoJanela');
			this._bg.x = (w - this._bg.width) / 2;
			this._bg.y = (h - this._bg.height) / 2;
			this.addChild(this._bg);
			
			if (fechar) {
				// botão fechar
				this._fechar = Main.graficos.getSPGR('BTCancel');
				this._fechar.width = this._fechar.height = 64;
				this._fechar.x = this._bg.x + this._bg.width - this._fechar.width - 10;
				this._fechar.y = this._bg.y + 10;
				this.addChild(this._fechar);
				this._fechar.addEventListener(MouseEvent.CLICK, onFechar);
			}
			
			// texto
			this._texto = new TextField();
			this._texto.defaultTextFormat = new TextFormat('_sans', 25, 0xe04d4c);
			this._texto.multiline = true;
			this._texto.wordWrap = true;
			this._texto.selectable = false;
			this._texto.x = this._bg.x + 10;
			this._texto.y = this._bg.y + 10;
			if (fechar) {
				this._texto.width = this._bg.width - 30 - this._fechar.width;
			} else {
				this._texto.width = this._bg.width - 20;
			}
			this._texto.height = this._bg.height - 20;
			this._texto.htmlText = tx;
			this.addChild(this._texto);
		}
		
		// FUNÇÕES PÚBLICAS
		
		/**
		 * Define o texto exibido.
		 * @param	tx	o novo texto
		 */
		public function defineTexto(tx:String):void
		{
			this._texto.htmlText = tx;
		}
		
		// FUNÇÕES PRIVADAS
		
		/**
		 * O botão fechar foi pressionado.
		 */
		private function onFechar(evt:MouseEvent):void
		{
			parent.removeChild(this);
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
	}

}