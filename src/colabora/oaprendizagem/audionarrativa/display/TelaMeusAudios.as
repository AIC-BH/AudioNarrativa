package colabora.oaprendizagem.audionarrativa.display 
{
	import colabora.oaprendizagem.servidor.Listagem;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class TelaMeusAudios extends TelaListaAudios
	{
		
		// VARIÁVEIS PRIVADAS
		
		private var _btabrir:Sprite;
		private var _btgravar:Sprite;
		private var _htmlIni:String;
		private var _htmlFim:String;
		private var _navegador:File;
		
		public function TelaMeusAudios() 
		{
			// preparando botões
			this._btabrir = Main.graficos.getSPGR('BTAbrirMp3');
			this._btabrir.addEventListener(MouseEvent.CLICK, onAbrir);
			this.addChild(this._btabrir);
			this._btgravar = Main.graficos.getSPGR('BTGravarMp3');
			this._btgravar.addEventListener(MouseEvent.CLICK, onGravar);
			this.addChild(this._btgravar);
			
			// recuperando textos html
			var stream:FileStream = new FileStream();
			stream.open(File.applicationDirectory.resolvePath('listaAudiosInicio.html'), FileMode.READ);
			this._htmlIni = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			stream.open(File.applicationDirectory.resolvePath('listaAudiosFim.html'), FileMode.READ);
			this._htmlFim = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			
			// navegador de arquivos
			this._navegador = File.documentsDirectory;
			this._navegador.addEventListener(Event.SELECT, onNavegadorSelect);
			this._navegador.addEventListener(Event.CANCEL, onNavegadorFim);
			this._navegador.addEventListener(IOErrorEvent.IO_ERROR, onNavegadorFim);
		}
		
		// GET/SET
		
		/**
		 * A pasta de gravação de arquivos.
		 */
		public function get pasta():File
		{
			return (this._pasta);
		}
		public function set pasta(to:File):void
		{
			this._pasta = to;
		}
		
		// VALORES SOMENTE LEITURA
		
		/**
		 * Listagem de arquivos de áudio deste projeto.
		 */
		override protected function get conteudoHtml():String 
		{
			// iniciando html
			var retorno:String = this._htmlIni;
			
			// conferindo arquivos na pasta de projto
			var total:int = 0;
			var lista:Array = this._pasta.getDirectoryListing();
			for (var i:int = 0; i < lista.length; i++) {
				var arquivo:File = lista[i] as File;
				if (arquivo.extension.toLowerCase() == 'mp3') {
					total++;
					retorno += '<div class="unselect" name="item" id="' + arquivo.name + '" onClick="onSelect(\'' + arquivo.name + '\', \'' + arquivo.name.split('.')[0] + '\');">' + arquivo.name.split('.')[0] + '</div>';
				}
			}
			
			// não há arquivos?
			if (total == 0) {
				retorno += 'Não foram encontrados arquivos de áudio para este projeto. Você pode acrescentar novos arquivos mp3 clicando no botão de pasta ao lado ou gravar novos áudios usando o botão de microfone.';
			}
			
			// finalizando html e retornando
			retorno += this._htmlFim;
			return (retorno);
		}
		
		// FUNÇÕES PRIVADAS
		
		/**
		 * A tela ficou disponível.
		 */
		override protected function onStage(evt:Event):void 
		{
			super.onStage(evt);
			
			// ajustando botões
			this._btabrir.width = this._btabrir.height = this._btplay.width;
			this._btgravar.width = this._btgravar.height = this._btplay.width;
			this._btabrir.x = this._btgravar.x = this._btplay.x;
			this._btabrir.y = (this._btplay.y + this._btplay.height) + this._btplay.y;
			this._btgravar.y = (this._btabrir.y + this._btabrir.height) + this._btplay.y;
		}
		
		/**
		 * Clique no botão abrir mp3.
		 */
		private function onAbrir(evt:MouseEvent):void
		{
			this._webview.loadString(this._htmlIni + 'Acrescentando um arquivo de áudio...' + this._htmlFim);
			this._navegador.browseForOpen('Importando áudio mp3', [new FileFilter('arquivos de áudio', '*.mp3')]);
		}
		
		/**
		 * Clique no botão gravar mp3.
		 */
		private function onGravar(evt:MouseEvent):void
		{
			parent.removeChild(this);
			this.dispatchEvent(new Event('gravar'));
		}
		
		/**
		 * Navegação por arquivo terminada sem nenhuma escolha.
		 */
		private function onNavegadorFim(evt:Event):void
		{
			// refazendo a listagem
			this._webview.loadString(this.conteudoHtml);
		}
		
		/**
		 * Recebendo um arquivo de áudio selecionado.
		 */
		private function onNavegadorSelect(evt:Event):void
		{
			// copiando o arquivo
			var nome:String = this._navegador.name;
			if (nome != null) {
				this._navegador.copyTo(this._pasta.resolvePath(nome), true);
			}
			// refazendo a listagem
			this._webview.loadString(this.conteudoHtml);
		}
		
	}

}