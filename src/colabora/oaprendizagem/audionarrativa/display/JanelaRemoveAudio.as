package colabora.oaprendizagem.audionarrativa.display 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class JanelaRemoveAudio extends JanelaEscolha
	{
		
		// VARIÁVEIS PRIVADAS
		
		private var _btSim:Sprite;
		private var _btNao:Sprite;
		
		public function JanelaRemoveAudio(w:Number, h:Number) 
		{
			super(w, h, 'Quer mesmo remover este áudio?');
			
			this._btSim = Main.graficos.getSPGR('BTOk');
			this._btNao = Main.graficos.getSPGR('BTCancel');
			
			var intervalo:Number = (this._bg.width - this._btSim.width - this._btNao.width) / 3;
			this._btSim.x = this._bg.x + intervalo;
			this._btNao.x = this._btSim.x + this._btSim.width + intervalo;
			this._btSim.y = this._bg.y + this._bg.height - this._btSim.height - 10;
			this._btNao.y = this._bg.y + this._bg.height - this._btNao.height - 10;
			
			this.addChild(this._btSim);
			this.addChild(this._btNao);
			
			this._btSim.addEventListener(MouseEvent.CLICK, onSim);
			this._btNao.addEventListener(MouseEvent.CLICK, onNao);
		}
		
		// FUNÇÕES PÚBLICAS
		
		/**
		 * Mostra informações sobre o áudio selecionado.
		 * @param	nome	nome do áudio
		 * @param	tr	trilha do áudio
		 * @param	dr	duração do áudio
		 */
		public function mostraAudio(nome:String, tr:int, dr:int):void
		{
			this.defineTexto('<b>Quer mesmo remover este áudio?</b><br />&nbsp;<br />nome: ' + nome + '<br />trilha: ' + (tr + 1) + '<br />duração: ' + dr + 's');
		}
		
		// FUNÇÕES PRIVADAS
		
		/**
		 * Clique no botão sim.
		 */
		private function onSim(evt:MouseEvent):void
		{
			parent.removeChild(this);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * Clique no botão não.
		 */
		private function onNao(evt:MouseEvent):void
		{
			parent.removeChild(this);
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
	}

}