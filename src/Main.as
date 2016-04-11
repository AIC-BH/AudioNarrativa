package
{
	import colabora.oaprendizagem.audionarrativa.dados.AudioNarrativa;
	import colabora.oaprendizagem.audionarrativa.display.AreaApp;
	import colabora.oaprendizagem.servidor.Servidor;
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import graphic.Graficos;
	
	import colabora.oaprendizagem.dados.ObjetoAprendizagem;
	
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class Main extends Sprite 
	{
		
		/**
		 * Informações sobre o projeto atual.
		 */
		public static var projeto:AudioNarrativa;
		
		/**
		 * Gráficos usados no app.
		 */
		public static var graficos:Graficos;
		
		/**
		 * Tela do app.
		 */
		public var appView:AreaApp;
		
		public function Main() 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// configurando app
			ObjetoAprendizagem.codigo = 'audionarrativas';
			ObjetoAprendizagem.nome = 'Áudio narrativas';
			ObjetoAprendizagem.urlServidor = 'http://localhost/oaprendizagem/web/';
			ObjetoAprendizagem.servidor = new Servidor();
			
			// preparando acesso aos gráficos
			Main.graficos = new Graficos();
			
			// criando o projeto atual
			Main.projeto = new AudioNarrativa();
			Main.projeto.addEventListener(Event.CHANGE, somAtualizado);
			
			
			
			
			// criando visualização do app
			this.appView = new AreaApp();
			this.addChild(this.appView);
			this.appView.posiciona();
			
			Main.projeto.carregaProjeto('primeiroprojeto');
			this.appView.desenhaTrilhas();
			Main.projeto.play();
			
			
			
			// atualizando display do app sempre que houver mudança na tela
			this.stage.addEventListener(Event.RESIZE, stageResize);
			
		}
		
		private function stageResize(evt:Event):void
		{
			this.appView.posiciona();
		}
		
		private function somAtualizado(evt:Event):void
		{
			this.appView.showPos(Main.projeto.tempoAtual);
		}
		
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			//NativeApplication.nativeApplication.exit();
		}
		
	}
	
}