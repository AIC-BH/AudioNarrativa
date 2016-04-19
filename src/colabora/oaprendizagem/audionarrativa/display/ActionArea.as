package colabora.oaprendizagem.audionarrativa.display 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class ActionArea extends Sprite
	{
		
		// VARÁVEIS PÚBLICAS
		
		public var acAjuda:Function;
		public var acMixer:Function;
		public var acInfo:Function;
		public var acNovo:Function;
		public var acAbrir:Function;
		public var acSalvar:Function;
		public var acArquivos:Function;
		public var acCompartilhar:Function;
		public var acReceber:Function;
		
		// VARIÁVEIS PRIVADAS
		
		private var _btAjuda:Sprite;
		private var _btMixer:Sprite;
		private var _btInfo:Sprite;
		private var _btNovo:Sprite;
		private var _btAbrir:Sprite;
		private var _btSalvar:Sprite;
		private var _btArquivos:Sprite;
		private var _btCompartilhar:Sprite;
		private var _btReceber:Sprite;
		
		public function ActionArea() 
		{
			// preparando imagens dos botões
			this._btAjuda = Main.graficos.getSPGR('BTAjuda');
			this._btMixer = Main.graficos.getSPGR('BTMixer');
			this._btInfo = Main.graficos.getSPGR('BTInfo');
			this._btNovo = Main.graficos.getSPGR('BTNovo');
			this._btAbrir = Main.graficos.getSPGR('BTAbrir');
			this._btSalvar = Main.graficos.getSPGR('BTSalvar');
			this._btArquivos = Main.graficos.getSPGR('BTArquivos');
			this._btCompartilhar = Main.graficos.getSPGR('BTCompartilhar');
			this._btReceber = Main.graficos.getSPGR('BTReceber');
			
			// ajustando posições
			var intervalo:Number = (AreaApp.AREAWIDTH - (9 * this._btAjuda.width)) / 10;
			this._btAjuda.x = intervalo;
			this._btMixer.x = this._btAjuda.x + this._btAjuda.width + intervalo;
			this._btInfo.x = this._btMixer.x + this._btMixer.width + intervalo;
			this._btNovo.x = this._btInfo.x + this._btInfo.width + intervalo;
			this._btAbrir.x = this._btNovo.x + this._btNovo.width + intervalo;
			this._btSalvar.x = this._btAbrir.x + this._btAbrir.width + intervalo;
			this._btArquivos.x = this._btSalvar.x + this._btSalvar.width + intervalo;
			this._btCompartilhar.x = this._btArquivos.x + this._btArquivos.width + intervalo;
			this._btReceber.x = this._btCompartilhar.x + this._btCompartilhar.width + intervalo;
			
			// adicionando botões à imagem
			this.addChild(this._btAjuda);
			this.addChild(this._btMixer);
			this.addChild(this._btInfo);
			this.addChild(this._btNovo);
			this.addChild(this._btAbrir);
			this.addChild(this._btSalvar);
			this.addChild(this._btArquivos);
			this.addChild(this._btCompartilhar);
			this.addChild(this._btReceber);
			
			// ouvindo cliques
			this._btAjuda.addEventListener(MouseEvent.CLICK, onAjuda);
			this._btMixer.addEventListener(MouseEvent.CLICK, onMixer);
			this._btInfo.addEventListener(MouseEvent.CLICK, onInfo);
			this._btNovo.addEventListener(MouseEvent.CLICK, onNovo);
			this._btAbrir.addEventListener(MouseEvent.CLICK, onAbrir);
			this._btSalvar.addEventListener(MouseEvent.CLICK, onSalvar);
			this._btArquivos.addEventListener(MouseEvent.CLICK, onArquivos);
			this._btCompartilhar.addEventListener(MouseEvent.CLICK, onCompartilhar);
			this._btReceber.addEventListener(MouseEvent.CLICK, onReceber);
		}
		
		// FUNÇÕES PRIVADAS
		
		private function onAjuda(evt:MouseEvent):void { if (this.acAjuda != null) this.acAjuda(); }
		private function onMixer(evt:MouseEvent):void { if (this.acMixer != null) this.acMixer(); }
		private function onInfo(evt:MouseEvent):void { if (this.acInfo != null) this.acInfo(); }
		private function onNovo(evt:MouseEvent):void { if (this.acNovo != null) this.acNovo(); }
		private function onAbrir(evt:MouseEvent):void { if (this.acAbrir != null) this.acAbrir(); }
		private function onSalvar(evt:MouseEvent):void { if (this.acSalvar != null) this.acSalvar(); }
		private function onArquivos(evt:MouseEvent):void { if (this.acArquivos != null) this.acArquivos(); }
		private function onCompartilhar(evt:MouseEvent):void { if (this.acCompartilhar != null) this.acCompartilhar(); }
		private function onReceber(evt:MouseEvent):void { if (this.acReceber != null) this.acReceber(); }
		
	}

}