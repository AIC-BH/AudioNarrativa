package colabora.oaprendizagem.audionarrativa.display 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import colabora.oaprendizagem.audionarrativa.dados.AudioNarrativa;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class AreaApp extends Sprite
	{
		/**
		 * Largura da tela de design do app.
		 */
		public static const AREAWIDTH:int = 1280;
		
		/**
		 * Altura da tela de design do app.
		 */
		public static const AREAHEIGHT:int = 720;
		
		/**
		 * Comprimento da lateral das caixas de áudio.
		 */
		public static const BOXSIDE:int = 128;
		
		/**
		 * Cor do fundo da tela do app.
		 */
		public static const CORBG:int = 0x333333;
		
		// VARIÁVEIS PRIVADAS
		
		private var _bg:Shape;							// fundo de tela
		private var _areasT:Vector.<AreaVazia>;			// áreas vazias das trilhas
		private var _fundoT:FundoTrilhas;				// imagem de fundo da área de trilhas
		private var _trilhas:Sprite;					// container para gráficos das trilhas
		private var _trilha0:Sprite;					// display da primeira trilha de botões
		private var _trilha1:Sprite;					// display da segunda trilha de botões
		private var _trilha2:Sprite;					// display da terceira trilha de botões
		private var _elementos:Vector.<AreaCheia>;		// elementos de áudio das trilhas
		
		private var _btplay:AppButton;
		private var _btpause:AppButton;
		private var _btvoltar:AppButton;
		private var _btvoltar10:AppButton;
		private var _btavancar:AppButton;
		private var _btavancar10:AppButton;
		private var _btinicio:AppButton;
		
		private var _telaPrincipal:Sprite;
		
		
		public function AreaApp() 
		{
			// preparando fundo
			this._bg = new Shape();
			this._bg.graphics.beginFill(AreaApp.CORBG);
			this._bg.graphics.drawRect(0, 0, AreaApp.AREAWIDTH, AreaApp.AREAHEIGHT);
			this._bg.graphics.endFill();
			this.addChild(this._bg);
			
			// preparando telas
			this._telaPrincipal = new Sprite();
			this.addChild(this._telaPrincipal);
			
			// preparando fundo de imagem de trilhas
			this._fundoT = new FundoTrilhas();
			this._telaPrincipal.addChild(this._fundoT);
			
			// preparando trilhas
			this._trilha0 = new Sprite();
			this._trilha1 = new Sprite();
			this._trilha2 = new Sprite();
			this._areasT = new Vector.<AreaVazia>();
			for (var i:int = 0; i < AudioNarrativa.MAXTIME; i++) {
				this._areasT.push(new AreaVazia(0, i));
				this._areasT[i].addEventListener(MouseEvent.CLICK, cliqueVazia);
				this._areasT[i].x = i * AreaApp.BOXSIDE;
				this._trilha0.addChild(this._areasT[i]);
			}
			for (i = 0; i < AudioNarrativa.MAXTIME; i++) {
				this._areasT.push(new AreaVazia(1, i));
				this._areasT[i + AudioNarrativa.MAXTIME].addEventListener(MouseEvent.CLICK, cliqueVazia);
				this._areasT[i + AudioNarrativa.MAXTIME].x = i * AreaApp.BOXSIDE;
				this._trilha1.addChild(this._areasT[i + AudioNarrativa.MAXTIME]);
			}
			for (i = 0; i < AudioNarrativa.MAXTIME; i++) {
				this._areasT.push(new AreaVazia(2, i));
				this._areasT[i + (2 * AudioNarrativa.MAXTIME)].addEventListener(MouseEvent.CLICK, cliqueVazia);
				this._areasT[i + (2 * AudioNarrativa.MAXTIME)].x = i * AreaApp.BOXSIDE;
				this._trilha2.addChild(this._areasT[i + (2 * AudioNarrativa.MAXTIME)]);
			}
			
			// preparando container de trilhas
			this._trilhas = new Sprite();
			this._trilhas.addChild(this._trilha0);
			this._trilha1.y = AreaApp.BOXSIDE;
			this._trilhas.addChild(this._trilha1);
			this._trilha2.y = 2 * AreaApp.BOXSIDE;
			this._trilhas.addChild(this._trilha2);
			this._trilhas.y = this._fundoT.y + (AreaApp.BOXSIDE / 2);
			this._telaPrincipal.addChild(this._trilhas);
			
			// botões
			this._btinicio = new AppButton(Main.graficos.getGR('BTInicio'), onInicio, false);
			this._btinicio.x = 0;
			this._btinicio.y = this._fundoT.y + this._fundoT.height - AreaApp.BOXSIDE;
			this._telaPrincipal.addChild(this._btinicio);
			
			this._btvoltar10 = new AppButton(Main.graficos.getGR('BTVoltar10'), onVoltar10);
			this._btvoltar10.x = 1 * AreaApp.BOXSIDE;
			this._btvoltar10.y = this._fundoT.y + this._fundoT.height - AreaApp.BOXSIDE;
			this._telaPrincipal.addChild(this._btvoltar10);
			
			this._btvoltar = new AppButton(Main.graficos.getGR('BTVoltar'), onVoltar);
			this._btvoltar.x = 2 * AreaApp.BOXSIDE;
			this._btvoltar.y = this._fundoT.y + this._fundoT.height - AreaApp.BOXSIDE;
			this._telaPrincipal.addChild(this._btvoltar);
			
			this._btavancar = new AppButton(Main.graficos.getGR('BTAvancar'), onAvancar);
			this._btavancar.x = 3 * AreaApp.BOXSIDE;
			this._btavancar.y = this._fundoT.y + this._fundoT.height - AreaApp.BOXSIDE;
			this._telaPrincipal.addChild(this._btavancar);
			
			this._btavancar10 = new AppButton(Main.graficos.getGR('BTAvancar10'), onAvancar10);
			this._btavancar10.x = 4 * AreaApp.BOXSIDE;
			this._btavancar10.y = this._fundoT.y + this._fundoT.height - AreaApp.BOXSIDE;
			this._telaPrincipal.addChild(this._btavancar10);
			
			this._btplay = new AppButton(Main.graficos.getGR('BTPlay'), onPlay, false);
			this._btplay.x = this._fundoT.x + this._fundoT.width - (2 * AreaApp.BOXSIDE);
			this._btplay.y = this._fundoT.y + this._fundoT.height - AreaApp.BOXSIDE;
			this._telaPrincipal.addChild(this._btplay);

			this._btpause = new AppButton(Main.graficos.getGR('BTPause'), onPause, false);
			this._btpause.x = this._fundoT.x + this._fundoT.width - (1 * AreaApp.BOXSIDE);
			this._btpause.y = this._fundoT.y + this._fundoT.height - AreaApp.BOXSIDE;
			this._telaPrincipal.addChild(this._btpause);
			
			
			// preparando elementos
			this._elementos = new Vector.<AreaCheia>();
			
			// posição inicial
			this.showPos(0);
			
			// repetições de botões
			if (this.stage != null) {
				this.stage.addEventListener(MouseEvent.MOUSE_UP, fimToque);
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			}
		}
		
		/**
		 * Posiciona a área do app na tela.
		 */
		public function posiciona():void
		{
			if (this.stage) {
				// definindo o novo tamanho
				var newWidth:Number = this.stage.stageWidth;
				var newHeight:Number = AreaApp.AREAHEIGHT * (newWidth / AreaApp.AREAWIDTH);
				if (newHeight > this.stage.stageHeight) {
					newHeight = this.stage.stageHeight;
					newWidth = AreaApp.AREAWIDTH * (newHeight / AreaApp.AREAHEIGHT);
				}
				this.scaleX = this.scaleY = newWidth / AreaApp.AREAWIDTH;
				// posicionando
				this.x = (this.stage.stageWidth - newWidth) / 2;
				this.y = (this.stage.stageHeight - newHeight) / 2;
			}
		}
		
		public function showPos(tempo:int):void
		{
			this._trilhas.x = (4 - tempo) *  AreaApp.BOXSIDE;
			this._fundoT.setNum(tempo - 4);
		}
		
		public function desenhaTrilhas():void
		{
			while (this._elementos.length > 0) {
				this._elementos[0].parent.removeChild(this._elementos[0]);
				this._elementos.shift().dispose();
			}
			var area:AreaCheia;
			// trilha 0
			for (var i:int = 0; i < Main.projeto.trilha[0].audio.length; i++) {
				area = new AreaCheia(0, Main.projeto.trilha[0].audio[i].duracao, Main.projeto.trilha[0].audio[i].titulo, Main.projeto.trilha[0].audio[i].tempo);
				this._trilha0.addChild(area);
				this._elementos.push(area);
			}
			// trilha 1
			for (i = 0; i < Main.projeto.trilha[1].audio.length; i++) {
				area = new AreaCheia(1, Main.projeto.trilha[1].audio[i].duracao, Main.projeto.trilha[1].audio[i].titulo, Main.projeto.trilha[1].audio[i].tempo);
				this._trilha1.addChild(area);
				this._elementos.push(area);
			}
			// trilha 2
			for (i = 0; i < Main.projeto.trilha[2].audio.length; i++) {
				area = new AreaCheia(2, Main.projeto.trilha[2].audio[i].duracao, Main.projeto.trilha[2].audio[i].titulo, Main.projeto.trilha[2].audio[i].tempo);
				this._trilha2.addChild(area);
				this._elementos.push(area);
			}
		}
		
		// FUNÇÕES PRIVADAS
		
		private function cliqueVazia(evt:MouseEvent):void
		{
			var clicada:AreaVazia = evt.target as AreaVazia;
			trace ('clique em', clicada.trilha, clicada.tempo);
		}
		
		private function onPlay():void
		{
			Main.projeto.play();
		}
		
		private function onPause():void
		{
			Main.projeto.pause();
		}
		
		private function onAvancar():void
		{
			Main.projeto.pause();
			Main.projeto.tempoAtual = Main.projeto.tempoAtual + 1;
			this.showPos(Main.projeto.tempoAtual);
		}
		
		private function onAvancar10():void
		{
			Main.projeto.pause();
			Main.projeto.tempoAtual = Main.projeto.tempoAtual + 10;
			this.showPos(Main.projeto.tempoAtual);
		}
		
		private function onVoltar():void
		{
			Main.projeto.pause();
			Main.projeto.tempoAtual = Main.projeto.tempoAtual - 1;
			this.showPos(Main.projeto.tempoAtual);
		}
		
		private function onVoltar10():void
		{
			Main.projeto.pause();
			Main.projeto.tempoAtual = Main.projeto.tempoAtual - 10;
			this.showPos(Main.projeto.tempoAtual);
		}
		
		private function onInicio():void
		{
			Main.projeto.stop();
			this.showPos(Main.projeto.tempoAtual);
		}
		
		private function onStage(evt:Event):void
		{
			this.stage.addEventListener(MouseEvent.MOUSE_UP, fimToque);
			this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		private function fimToque(evt:MouseEvent = null):void
		{
			this._btavancar.fimToque();
			this._btavancar10.fimToque();
			this._btvoltar.fimToque();
			this._btvoltar10.fimToque();
		}
		
	}

}