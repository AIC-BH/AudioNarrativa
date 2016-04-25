package colabora.oaprendizagem.audionarrativa.display 
{
	import art.ciclope.managana.net.Webview;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class TelaListaAudios extends Sprite
	{
		
		// VARIÁVEIS PRIVADAS
		
		protected var _webview:Webview;
		protected var _btcancel:Sprite;
		protected var _btplay:Sprite;
		protected var _btstop:Sprite;
		protected var _btok:Sprite;
		protected var _bg:Shape;
		protected var _sound:Sound;
		protected var _channel:SoundChannel;
		protected var _duracao:int = -1;
		protected var _selecionado:Object;
		protected var _pasta:File;
		
		public function TelaListaAudios() 
		{
			// fundo
			this._bg = new Shape();
			this._bg.graphics.beginFill(0x38332b);
			this._bg.graphics.drawRect(0, 0, 100, 100);
			this._bg.graphics.endFill();
			this.addChild(this._bg);
			
			// webview
			this._webview = new Webview();
			this._webview.setCallback('select', onSelect);
			
			// cancel
			this._btcancel = Main.graficos.getSPGR('BTCancel');
			this._btcancel.addEventListener(MouseEvent.CLICK, onCancel);
			this.addChild(this._btcancel);
			
			// ok
			this._btok = Main.graficos.getSPGR('BTOk');
			this._btok.addEventListener(MouseEvent.CLICK, onOk);
			this.addChild(this._btok);
			
			// play
			this._btplay = Main.graficos.getSPGR('BTPlay');
			this._btplay.addEventListener(MouseEvent.CLICK, onPlay);
			this.addChild(this._btplay);
			
			// stop
			this._btstop = Main.graficos.getSPGR('BTStop');
			this._btstop.addEventListener(MouseEvent.CLICK, onStop);
			this.addChild(this._btstop);
			
			// adicionado à tela
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onNoStage);
		}
		
		// VALORES SOMENTE LEITURA
		
		/**
		 * Informações sobre o áudio selecionado.
		 */
		public function get selecionado():Object
		{
			var retorno:Object;
			if (this._selecionado != null) {
				if ((this._selecionado.arquivo != null) && (this._selecionado.titulo != null) && (this._duracao >= 1)) {
					retorno = new Object();
					retorno.arquivo = this._selecionado.arquivo;
					retorno.titulo = this._selecionado.titulo;
					retorno.duracao = this._duracao;
				}
			}
			return (retorno);
		}
		
		/**
		 * Conteúdo a ser exibido no webview (a ser sobrescrito).
		 */
		protected function get conteudoHtml():String
		{
			return('');
		}
		
		// FUNÇÕES PRIVADAS
		
		/**
		 * A tela ficou disponível.
		 */
		protected function onStage(evt:Event):void
		{
			// fundo
			this._bg.width = stage.stageWidth;
			this._bg.height = stage.stageHeight;
			
			// tamanho dos botões
			var tamanho:Number = stage.stageHeight / 7;
			this._btcancel.width = this._btcancel.height = tamanho;
			this._btok.width = this._btok.height = tamanho;
			this._btplay.width = this._btplay.height = tamanho;
			this._btstop.width = this._btstop.height = tamanho;
			
			// intervalo
			var intervalo:Number = ((2 * (stage.stageHeight / 7)) / 6);
			
			// posições
			this._btplay.x = stage.stageWidth - 10 - this._btplay.width;
			this._btplay.y = intervalo;
			this._btstop.x = this._btplay.x;
			this._btstop.y = this._btplay.y;
			this._btcancel.x = stage.stageWidth - 10 - this._btcancel.width;
			this._btcancel.y = stage.stageHeight - intervalo - this._btcancel.height;
			this._btok.x = stage.stageWidth - 10 - this._btok.width;
			this._btok.y = this._btcancel.y - intervalo - this._btok.height;
			
			// play/stop
			this._btplay.visible = true;
			this._btstop.visible = false;
			this.canalCompleto();
			
			// webview
			this._webview.viewPort = new Rectangle(10, 10, (stage.stageWidth - 30 - this._btplay.width), (stage.stageHeight - 20));
			this._webview.stage = this.stage;
			this._webview.loadString(this.conteudoHtml);
		}
		
		/**
		 * Retirado da tela.
		 */
		private function onNoStage(evt:Event):void
		{
			this.canalCompleto();
			this._webview.stage = null;
		}
		
		/**
		 * Clique no botão cancelar.
		 */
		private function onCancel(evt:MouseEvent):void
		{
			this.canalCompleto();
			this._webview.stage = null;
			parent.removeChild(this);
			this.dispatchEvent(new Event(Event.CANCEL));
		}
		
		/**
		 * Clique no botão ok.
		 */
		private function onOk(evt:MouseEvent):void
		{
			if (this.selecionado != null) {
				this.canalCompleto();
				this._webview.stage = null;
				parent.removeChild(this);
				this.dispatchEvent(new Event(Event.SELECT));
			}
		}
		
		/**
		 * Clique no botão play.
		 */
		private function onPlay(evt:MouseEvent):void
		{
			if ((this._sound != null) && (this._duracao >= 1)) {
				this.canalCompleto();
				this._channel = this._sound.play();
				this._channel.addEventListener(Event.SOUND_COMPLETE, canalCompleto);
				this._btplay.visible = false;
				this._btstop.visible = true;
			}
		}
		
		/**
		 * Clique no botão stop.
		 */
		private function onStop(evt:MouseEvent):void
		{
			this.canalCompleto();
			this._btplay.visible = true;
			this._btstop.visible = false;
		}
		
		/**
		 * Um áudio foi selecionado na lista.
		 * @param	dados	informações sobre o áudio selecionado
		 */
		private function onSelect(dados:Object):void
		{
			this._duracao = -1;
			this._selecionado = dados;
			if (this._sound != null) {
				if (this._sound.hasEventListener(Event.COMPLETE)) this._sound.removeEventListener(Event.COMPLETE, somCarregado);
				try { this._sound.close(); } catch (e:Error) { }
				this._sound = null;
			}
			this._sound = new Sound();
			this._sound.addEventListener(Event.COMPLETE, somCarregado);
			this._sound.load(new URLRequest(this._pasta.resolvePath(dados.arquivo).url));
		}
		
		/**
		 * Um arquivo de som foi carregado.
		 */
		private function somCarregado(evt:Event):void
		{
			this._duracao = int(Math.ceil(this._sound.length / 1000));
		}
		
		/**
		 * O áudio do canal terminou ou foi interrompido.
		 */
		private function canalCompleto(evt:Event = null):void
		{
			if (this._channel != null) {
				this._channel.stop();
				this._channel.removeEventListener(Event.SOUND_COMPLETE, canalCompleto);
				this._channel = null;
			}
			this._btplay.visible = true;
			this._btstop.visible = false;
		}
		
	}

}