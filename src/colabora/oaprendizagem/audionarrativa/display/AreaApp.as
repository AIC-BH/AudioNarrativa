package colabora.oaprendizagem.audionarrativa.display 
{
	import art.ciclope.data.PersistentData;
	import art.ciclope.io.FileBrowser;
	import colabora.display.EscolhaProjeto;
	import colabora.display.TelaAjuda;
	import colabora.display.TelaHelpInicio;
	import colabora.display.TelaMensagem;
	import colabora.oaprendizagem.dados.ObjetoAprendizagem;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import colabora.oaprendizagem.audionarrativa.dados.AudioNarrativa;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
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
		public static const CORBG:int = 0xFFFFFF;
		
		// VARIÁVEIS PRIVADAS
		
		private var _bg:Shape;							// fundo de tela
		private var _areasT:Vector.<AreaVazia>;			// áreas vazias das trilhas
		private var _fundoT:FundoTrilhas;				// imagem de fundo da área de trilhas
		private var _trilhas:Sprite;					// container para gráficos das trilhas
		private var _trilha0:Sprite;					// display da primeira trilha de botões
		private var _trilha1:Sprite;					// display da segunda trilha de botões
		private var _trilha2:Sprite;					// display da terceira trilha de botões
		private var _elementos:Vector.<AreaCheia>;		// elementos de áudio das trilhas
		private var _audioAtual:AreaCheia;				// referência ao último elemento de áudio clicado
		private var _audioNova:AreaVazia;				// referência à última área de inclusão de áudio clicada
		
		private var _save:PersistentData;
		
		private var _btplay:AppButton;
		private var _btpause:AppButton;
		private var _btvoltar:AppButton;
		private var _btvoltar10:AppButton;
		private var _btavancar:AppButton;
		private var _btavancar10:AppButton;
		private var _btinicio:AppButton;
		
		private var _telaPrincipal:Sprite;
		private var _telaEscolha:EscolhaProjeto;
		private var _telaAjuda:TelaAjuda;
		private var _telaMensagem:TelaMensagem;
		private var _incluiAudio:JanelaIncluiAudio;
		private var _removeAudio:JanelaRemoveAudio;
		private var _telaBiblioteca:TelaBiblioteca;
		private var _telaMeusAudios:TelaMeusAudios;
		private var _telaGravacao:TelaGravacao;
		private var _telaInfo:TelaInfo;
		private var _ajudainloco:TelaHelpInicio;
		
		
		private var _acoes:ActionArea;
		private var _acAtual:String = '';
		
		private var _navegaProjeto:File;
		private var _navegaMobile:FileBrowser;
		
		
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
			
			var intervalo:Number = (AreaApp.AREAWIDTH - (8 * this._btinicio.width)) / 9;
			
			this._btinicio.x = intervalo;
			this._btinicio.y = this._fundoT.y + this._fundoT.height - AreaApp.BOXSIDE;
			this._telaPrincipal.addChild(this._btinicio);
			
			this._btvoltar10 = new AppButton(Main.graficos.getGR('BTVoltar10'), onVoltar10);
			this._btvoltar10.x = this._btinicio.x + this._btinicio.width + intervalo;
			this._btvoltar10.y = this._fundoT.y + this._fundoT.height - AreaApp.BOXSIDE;
			this._telaPrincipal.addChild(this._btvoltar10);
			
			this._btvoltar = new AppButton(Main.graficos.getGR('BTVoltar'), onVoltar);
			this._btvoltar.x = this._btvoltar10.x + this._btvoltar10.width + intervalo;
			this._btvoltar.y = this._fundoT.y + this._fundoT.height - AreaApp.BOXSIDE;
			this._telaPrincipal.addChild(this._btvoltar);
			
			this._btavancar = new AppButton(Main.graficos.getGR('BTAvancar'), onAvancar);
			this._btavancar.x = this._btvoltar.x + this._btvoltar.width + intervalo;
			this._btavancar.y = this._fundoT.y + this._fundoT.height - AreaApp.BOXSIDE;
			this._telaPrincipal.addChild(this._btavancar);
			
			this._btavancar10 = new AppButton(Main.graficos.getGR('BTAvancar10'), onAvancar10);
			this._btavancar10.x = this._btavancar.x + this._btavancar.width + intervalo;
			this._btavancar10.y = this._fundoT.y + this._fundoT.height - AreaApp.BOXSIDE;
			this._telaPrincipal.addChild(this._btavancar10);
			
			this._btplay = new AppButton(Main.graficos.getGR('BTPlay'), onPlay, false);
			this._btplay.x = AreaApp.AREAWIDTH - this._btplay.width - intervalo;
			this._btplay.y = this._fundoT.y + this._fundoT.height - AreaApp.BOXSIDE;
			this._telaPrincipal.addChild(this._btplay);

			this._btpause = new AppButton(Main.graficos.getGR('BTPause'), onPause, false);
			this._btpause.x = this._btplay.x - this._btpause.width - intervalo;
			this._btpause.y = this._fundoT.y + this._fundoT.height - AreaApp.BOXSIDE;
			this._telaPrincipal.addChild(this._btpause);
			
			// botões de ação
			this._acoes = new ActionArea();
			this._acoes.y = this._telaPrincipal.height + ((AreaApp.AREAHEIGHT - this._telaPrincipal.height - this._acoes.height) / 2);
			this._telaPrincipal.addChild(this._acoes);
			this._acoes.acAbrir = this.acAbrirPrjeto;
			this._acoes.acAjuda = this.acAjuda;
			this._acoes.acArquivos = this.acExportarProjeto;
			this._acoes.acNovo = this.acNovo;
			this._acoes.acSalvar = this.acSalvar;
			this._acoes.acCompartilhar = this.acCompartilhar;
			this._acoes.acReceber = this.acReceber;
			this._acoes.acInfo = this.acInfo;
			
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
			
			// tela de escolha de projetos
			this._telaEscolha = new EscolhaProjeto('Escolha o projeto',
													Main.graficos.getSPGR('BTOk'),
													Main.graficos.getSPGR('BTCancel'),
													Main.graficos.getSPGR('BTAbrir'),
													Main.graficos.getSPGR('BTLixeira'),
													File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/projetos/' ),
													0xfbe0cc);
			this._telaEscolha.addEventListener(Event.COMPLETE, onEscolhaOK);
			this._telaEscolha.addEventListener(Event.CANCEL, onEscolhaCancel);
			this._telaEscolha.addEventListener(Event.OPEN, onEscolhaOpen);
			this._telaEscolha.addEventListener(Event.CLEAR, onEscolhaClear);
			
			// tela de ajuda
			var ajuda:Vector.<Bitmap> = new Vector.<Bitmap>();
			ajuda.push(Main.graficos.getGR('AJUDA01'));
			ajuda.push(Main.graficos.getGR('AJUDA02'));
			ajuda.push(Main.graficos.getGR('AJUDA03'));
			ajuda.push(Main.graficos.getGR('AJUDA04'));
			ajuda.push(Main.graficos.getGR('AJUDA05'));
			ajuda.push(Main.graficos.getGR('AJUDA06'));
			ajuda.push(Main.graficos.getGR('AJUDA07'));
			ajuda.push(Main.graficos.getGR('AJUDA08'));
			ajuda.push(Main.graficos.getGR('AJUDA09'));
			ajuda.push(Main.graficos.getGR('AJUDA10'));
			ajuda.push(Main.graficos.getGR('AJUDA11'));
			ajuda.push(Main.graficos.getGR('AJUDA12'));
			ajuda.push(Main.graficos.getGR('AJUDA13'));
			ajuda.push(Main.graficos.getGR('AJUDA14'));
			ajuda.push(Main.graficos.getGR('AJUDA15'));
			ajuda.push(Main.graficos.getGR('AJUDA16'));
			
			this._telaAjuda = new TelaAjuda(ajuda, Main.graficos.getSPGR('BTDireita'), Main.graficos.getSPGR('BTEsquerda'), Main.graficos.getSPGR('BTFechar'));
			this._telaAjuda.adicionaBotao(Main.graficos.getSPGR('BTHelp1'), 0);
			this._telaAjuda.adicionaBotao(Main.graficos.getSPGR('BTHelp2'), 10);
			this._telaAjuda.adicionaBotao(Main.graficos.getSPGR('BTHelp3'), 14);
			
			// navegação para importar projeto
			this._navegaProjeto = File.documentsDirectory;
			this._navegaProjeto.addEventListener(Event.SELECT, onNavegadorPSelect);
			this._navegaProjeto.addEventListener(Event.CANCEL, onNavegadorPFim);
			this._navegaProjeto.addEventListener(IOErrorEvent.IO_ERROR, onNavegadorPFim);
			
			// navegação de importação em aparelhos móveis
			this._navegaMobile = new FileBrowser(Main.graficos.getSPGR('BTOk'), Main.graficos.getSPGR('BTCancel'), 0xfbe0cc);
			this._navegaMobile.addEventListener(Event.COMPLETE, onNavegadorMobSelect);
			this._navegaMobile.addEventListener(Event.CANCEL, onNavegadorMobFim);
			
			// tela de mensagens
			this._telaMensagem = new TelaMensagem(AreaApp.AREAWIDTH,
													AreaApp.AREAHEIGHT,
													Main.graficos.getSPGR('BTOk'),
													Main.graficos.getSPGR('BTCancel'),
													0xFFFFFF, 
													0xe04d4c);
			this._telaMensagem.addEventListener(Event.COMPLETE, onMensagemOK);
			this._telaMensagem.addEventListener(Event.CANCEL, onMensagemCancel);
			
			// tela de compartilhamento
			ObjetoAprendizagem.compartilhamento.addEventListener(Event.CLOSE, onCompartilhamentoClose);
			ObjetoAprendizagem.compartilhamento.addEventListener(Event.COMPLETE, onCompartilhamentoComplete);
			
			// importação de projetos
			Main.projeto.addEventListener(Event.CANCEL, onImportCancel);
			Main.projeto.addEventListener(Event.COMPLETE, onImportComplete);
			
			// inclusão e remoção de áudio
			this._incluiAudio = new JanelaIncluiAudio(AreaApp.AREAWIDTH, AreaApp.AREAHEIGHT);
			this._incluiAudio.addEventListener('biblioteca', onIncluiBiblioteca);
			this._incluiAudio.addEventListener('meusaudios', onIncluiMeusAudios);
			this._removeAudio = new JanelaRemoveAudio(AreaApp.AREAWIDTH, AreaApp.AREAHEIGHT);
			this._removeAudio.addEventListener(Event.COMPLETE, onRemoveSim);
			this._removeAudio.addEventListener(Event.CLOSE, onRemoveNao);
			
			// biblioteca de áudios
			this._telaBiblioteca = new TelaBiblioteca();
			this._telaBiblioteca.addEventListener(Event.CANCEL, onBibliotecaCancel);
			this._telaBiblioteca.addEventListener(Event.SELECT, onBibliotecaSelect);
			
			// meus áudios
			this._telaMeusAudios = new TelaMeusAudios();
			this._telaMeusAudios.addEventListener(Event.CANCEL, onMeusAudiosCancel);
			this._telaMeusAudios.addEventListener(Event.SELECT, onMeusAudiosSelect);
			this._telaMeusAudios.addEventListener('gravar', onGravar);
			
			// gravação de áudio
			this._telaGravacao = new TelaGravacao(AreaApp.AREAWIDTH, AreaApp.AREAHEIGHT);
			this._telaGravacao.addEventListener(Event.CANCEL, onGravacaoCancel);
			this._telaGravacao.addEventListener(Event.COMPLETE, onGravacaoComplete);
			
			// informações sobre o projeto
			this._telaInfo = new TelaInfo(AreaApp.AREAWIDTH, AreaApp.AREAHEIGHT);
			this._telaInfo.addEventListener(Event.COMPLETE, onInfoComplete);
			
			// dados persistentes
			this._save = new PersistentData(ObjetoAprendizagem.codigo);
			if (this._save.isSet('ultimo')) {
				//if (Main.projeto.carregaProjeto(this._save.getValue('ultimo'))) this.desenhaTrilhas();
			}
			
			// ajuda in-loco
			this._ajudainloco = new TelaHelpInicio(Main.graficos.getGR('AJUDAINLOCO'));
			this.addChild(this._ajudainloco);
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
		
		/**
		 * Mostra uma posição na trilha.
		 * @param	tempo	tempo em segundos a mostrar
		 */
		public function showPos(tempo:int):void
		{
			this._trilhas.x = (4 - tempo) *  AreaApp.BOXSIDE;
			this._fundoT.setNum(tempo - 4);
		}
		
		/**
		 * Redesenha as tilhas na tela.
		 */
		public function desenhaTrilhas():void
		{
			while (this._elementos.length > 0) {
				this._elementos[0].parent.removeChild(this._elementos[0]);
				this._elementos[0].removeEventListener(MouseEvent.CLICK, cliqueAudio);
				this._elementos.shift().dispose();
			}
			var area:AreaCheia;
			// trilha 0
			for (var i:int = 0; i < Main.projeto.trilha[0].audio.length; i++) {
				area = new AreaCheia(0, Main.projeto.trilha[0].audio[i].duracao, Main.projeto.trilha[0].audio[i].titulo, Main.projeto.trilha[0].audio[i].tempo);
				this._trilha0.addChild(area);
				this._elementos.push(area);
				area.addEventListener(MouseEvent.CLICK, cliqueAudio);
			}
			// trilha 1
			for (i = 0; i < Main.projeto.trilha[1].audio.length; i++) {
				area = new AreaCheia(1, Main.projeto.trilha[1].audio[i].duracao, Main.projeto.trilha[1].audio[i].titulo, Main.projeto.trilha[1].audio[i].tempo);
				this._trilha1.addChild(area);
				this._elementos.push(area);
				area.addEventListener(MouseEvent.CLICK, cliqueAudio);
			}
			// trilha 2
			for (i = 0; i < Main.projeto.trilha[2].audio.length; i++) {
				area = new AreaCheia(2, Main.projeto.trilha[2].audio[i].duracao, Main.projeto.trilha[2].audio[i].titulo, Main.projeto.trilha[2].audio[i].tempo);
				this._trilha2.addChild(area);
				this._elementos.push(area);
				area.addEventListener(MouseEvent.CLICK, cliqueAudio);
			}
		}
		
		/**
		 * Salva projeto atual e guarda referência para abrir novamente no futuro.
		 */
		public function salvar():void
		{
			Main.projeto.salvar();
			this._save.setValue('ultimo', Main.projeto.id);
		}
		
		// FUNÇÕES PRIVADAS
		
		/**
		 * Clique em uma área vazia nas trilhas.
		 */
		private function cliqueVazia(evt:MouseEvent):void
		{
			this._audioNova = evt.target as AreaVazia;
			Main.projeto.pause();
			this.addChild(this._incluiAudio);
		}
		
		/**
		 * Clique em uma área de áudio nas trilhas.
		 */
		private function cliqueAudio(evt:MouseEvent):void
		{
			this._audioAtual = evt.target as AreaCheia;
			this._removeAudio.mostraAudio(this._audioAtual.nome, this._audioAtual.track, this._audioAtual.duracao);
			this.addChild(this._removeAudio);
		}
		
		/**
		 * Tocar o áudio.
		 */
		private function onPlay():void
		{
			Main.projeto.play();
		}
		
		/**
		 * Pausar o áudio.
		 */
		private function onPause():void
		{
			Main.projeto.pause();
		}
		
		/**
		 * Avançar 1 segundo na trilha.
		 */
		private function onAvancar():void
		{
			Main.projeto.pause();
			Main.projeto.tempoAtual = Main.projeto.tempoAtual + 1;
			this.showPos(Main.projeto.tempoAtual);
		}
		
		/**
		 * Avançar 10 segundos na trilha.
		 */
		private function onAvancar10():void
		{
			Main.projeto.pause();
			Main.projeto.tempoAtual = Main.projeto.tempoAtual + 10;
			this.showPos(Main.projeto.tempoAtual);
		}
		
		/**
		 * Voltar 1 segundo na trilha.
		 */
		private function onVoltar():void
		{
			Main.projeto.pause();
			Main.projeto.tempoAtual = Main.projeto.tempoAtual - 1;
			this.showPos(Main.projeto.tempoAtual);
		}
		
		/**
		 * Voltar 10 segundos na trilha.
		 */
		private function onVoltar10():void
		{
			Main.projeto.pause();
			Main.projeto.tempoAtual = Main.projeto.tempoAtual - 10;
			this.showPos(Main.projeto.tempoAtual);
		}
		
		/**
		 * Voltar a trilha para o tempo 0.
		 */
		private function onInicio():void
		{
			Main.projeto.stop();
			this.showPos(Main.projeto.tempoAtual);
		}
		
		/**
		 * Stage ficou disponível.
		 */
		private function onStage(evt:Event):void
		{
			this.stage.addEventListener(MouseEvent.MOUSE_UP, fimToque);
			this.removeEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		/**
		 * Fim de um toque na tela.
		 */
		private function fimToque(evt:MouseEvent = null):void
		{
			this._btavancar.fimToque();
			this._btavancar10.fimToque();
			this._btvoltar.fimToque();
			this._btvoltar10.fimToque();
		}
		
		/**
		 * Um projeto foi escolhido na tela de listagem.
		 */
		private function onEscolhaOK(evt:Event):void
		{
			var acOK:Boolean = false;
			switch (this._acAtual) {
				case 'abrir projeto':
					if (this._telaEscolha.escolhido != null) {
						if (this._telaEscolha.escolhido.id != null) {
							// salvar projeto atual
							this.salvar();
							// carregar o projeto selecionado
							if (Main.projeto.carregaProjeto(this._telaEscolha.escolhido.id)) Main.projeto.tempoAtual = 0;
							this.desenhaTrilhas();
							// ação ok
							acOK = true;
						}
					}
					if (!acOK) {
						// avisar sobre problema ao abrir projeto
						this.stage.removeChild(this._telaEscolha);
						this._telaMensagem.defineMensagem('<b>Oh, não!</b><br />&nbsp;<br />Não consegui abrir a narrativa que você escolheu. Que tal tentar mais uma vez?');
						this.addChild(this._telaMensagem);
					} else {
						// mostrar projeto aberto
						this.stage.removeChild(this._telaEscolha);
						this.addChild(this._telaPrincipal);
					}
					break;
				case 'exportar projeto':
					if (this._telaEscolha.escolhido != null) {
						if (this._telaEscolha.escolhido.id != null) {
							// recuperando nome de arquivo
							var exportado:String = Main.projeto.exportarID(this._telaEscolha.escolhido.id as String);
							if (exportado != '') {
								// ação ok
								acOK = true;
							}
						}
					}
					if (!acOK) {
						// avisar sobre problema ao exportar projeto
						this.stage.removeChild(this._telaEscolha);
						this._telaMensagem.defineMensagem('<b>Desculpe...</b><br />&nbsp;<br />Não consegui exportar sua narrativa. Vamos tentar de novo?');
						this.addChild(this._telaMensagem);
					} else {
						// avisar sobre o projeto exportado
						this.stage.removeChild(this._telaEscolha);
						this._telaMensagem.defineMensagem('<b>Prontinho ;-)</b><br />&nbsp;<br />Sua narrativa foi exportada. Ela está gravada com o nome <br />&nbsp;<br /><b>' + exportado + '</b><br />&nbsp;<br />na pasta <br />&nbsp;<br /><b>' + File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/exportados').nativePath + '</b><br />&nbsp;<br />de seu aparelho.');
						this.addChild(this._telaMensagem);
					}
					break;
				default:
					this.stage.removeChild(this._telaEscolha);
					this.addChild(this._telaPrincipal);
					break;
			}
			
		}
		
		/**
		 * Um projeto foi escolhido para apagar tela de listagem.
		 */
		private function onEscolhaClear(evt:Event):void
		{
			// existe informação sobre o projeto a remover?
			if (this._telaEscolha.escolhido != null) {
				if (this._telaEscolha.escolhido.id != null) {
					if (this._telaEscolha.escolhido.titulo == '') this._telaEscolha.escolhido.titulo = 'sem nome';
					this._telaMensagem.defineMensagem('<b>Quer mesmo apagar?</b><br />&nbsp;<br />Quer mesmo apagar a narrativa <b>' + this._telaEscolha.escolhido.titulo + '</b>? Se fizer isso, não vou conseguir recuperá-la se você mudar de ideia.', true);
					this._acAtual = 'apaga projeto';
					this.stage.removeChild(this._telaEscolha);
					this.addChild(this._telaMensagem);
				}
			}
		}
		
		/**
		 * O botão cancelar foi escolhido na tela de listagem de projetos.
		 */
		private function onEscolhaCancel(evt:Event):void
		{
			this.stage.removeChild(this._telaEscolha);
			this.addChild(this._telaPrincipal);
		}
		
		/**
		 * O botão abrir foi escolhido na tela de listagem de projetos.
		 */
		private function onEscolhaOpen(evt:Event):void
		{
			if (Main.desktop) {
				this._telaEscolha.mostrarMensagem('Localizando e importanto um arquivo de projeto.');
				this._navegaProjeto.browseForOpen('Projetos de Narrativa de Áudio', [new FileFilter('arquivos de projeto', '*.adn')]);
			} else {
				this._telaEscolha.parent.removeChild(this._telaEscolha);
				this._navegaMobile.listar('adn', 'Escolha um projeto para importar');
				this.stage.addChild(this._navegaMobile);
			}
		}
		
		/**
		 * Navegação por arquivo móvel terminada sem nenhuma escolha.
		 */
		private function onNavegadorMobFim(evt:Event):void
		{
			// refazendo a listagem
			this._navegaMobile.parent.removeChild(this._navegaMobile);
			this._telaEscolha.listar('Defina o projeto a exportar ou escolha um arquivo para importar');
			this.stage.addChild(this._telaEscolha);
		}
		
		/**
		 * Recebendo um arquivo móvel de projeto selecionado.
		 */
		private function onNavegadorMobSelect(evt:Event):void
		{
			// importando
			this._navegaMobile.parent.removeChild(this._navegaMobile);
			var arq:File = new File(this._navegaMobile.escolhido.arquivo);
			if (Main.projeto.importar(arq)) {
				// aguardar importação
			} else {
				// somente listar novamente
				this._telaEscolha.listar('Erro ao importar o projeto: defina o projeto a exportar ou escolha um arquivo para importar');
				this.stage.addChild(this._telaEscolha);
			}
		}
		
		/**
		 * Navegação por arquivo terminada sem nenhuma escolha.
		 */
		private function onNavegadorPFim(evt:Event):void
		{
			// refazendo a listagem
			this._telaEscolha.listar();
		}
		
		/**
		 * Recebendo um arquivo de projeto selecionado.
		 */
		private function onNavegadorPSelect(evt:Event):void
		{
			// importando
			if (Main.projeto.importar(this._navegaProjeto)) {
				// aguardar importação
				this.stage.removeChild(this._telaEscolha);
			} else {
				// somentar listar novamente
				this._telaEscolha.listar();
			}
		}
		
		/**
		 * O notão OK da tela de mensagem foi clicado.
		 */
		private function onMensagemOK(evt:Event):void
		{
			var acOK:Boolean = false;
			switch (this._acAtual) {
				case 'novo projeto':
					Main.projeto.clear();
					Main.projeto.tempoAtual = 0;
					this.desenhaTrilhas();
					this.removeChild(this._telaMensagem);
					this.addChild(this._telaPrincipal);
					break;
				case 'salvar projeto':
					this.salvar();
					this.removeChild(this._telaMensagem);
					this.addChild(this._telaPrincipal);
					break;
				case 'compartilhar projeto':
					var exportado:String = Main.projeto.exportar();
					if (exportado != '') {
						// ação ok
						acOK = true;
					}
					if (!acOK) {
						// avisar sobre problema ao exportar projeto
						this._acAtual = 'erro compartilhando projeto';
						this._telaMensagem.defineMensagem('<b>Ops, alguma coisa deu errado...</b><br />&nbsp;<br />Não consegui exportar a sua narrativa para compartilhamento. Quer tentar de novo?');
					} else {
						// iniciar compartilhamento
						if (ObjetoAprendizagem.compartilhamento.iniciaURL(File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/exportados/' + exportado))) {
							this.removeChild(this._telaMensagem);
							this.stage.addChild(ObjetoAprendizagem.compartilhamento);
						} else {
							// avisar sobre erro de compartilhamento
							this._acAtual = 'erro compartilhando projeto';
							this._telaMensagem.defineMensagem('<b>Desculpe...</b><br />&nbsp;<br />Não consegui exportar a sua narrativa para compartilhamento. Vamos tentar mais uma vez?');
						}
					}
					break;
				case 'apaga projeto':
					if (this._telaEscolha.escolhido != null) {
						if (this._telaEscolha.escolhido.id != null) {
							if (String(this._telaEscolha.escolhido.id) == Main.projeto.id) {
								// o projeto a apagar é o atual
								Main.projeto.clear();
								this.desenhaTrilhas();
							}
							// removendo pasta do projeto
							Main.projeto.apagaProjeto(String(this._telaEscolha.escolhido.id));
						}
					}
					this.removeChild(this._telaMensagem);
					this.addChild(this._telaPrincipal);
					break;
				default:
					this.removeChild(this._telaMensagem);
					this.addChild(this._telaPrincipal);
					break;
			}
			
		}
		
		/**
		 * O botão cancelar foi escolhido na tela de mensagens.
		 */
		private function onMensagemCancel(evt:Event):void
		{
			this.removeChild(this._telaMensagem);
			this.addChild(this._telaPrincipal);
		}
		
		/**
		 * A tela de compartilhamento foi fechada.
		 */
		private function onCompartilhamentoClose(evt:Event):void
		{
			this.addChild(this._telaPrincipal);
		}
		
		/**
		 * Foi recebido um arquivo de projeto.
		 */
		private function onCompartilhamentoComplete(evt:Event):void
		{
			this._acAtual = 'projeto recebido';
			if (!Main.projeto.importar(ObjetoAprendizagem.compartilhamento.download)) {
				this._telaMensagem.defineMensagem('<b>Oh, não!</b><br />&nbsp;<br />Não consegui impotar a narrativa que você escolheu. Quer tentar novamente?');
				this.stage.removeChild(ObjetoAprendizagem.compartilhamento);
				this.addChild(this._telaMensagem);
			}
		}
		
		/**
		 * Falha na importação de um projeto.
		 */
		private function onImportComplete(evt:Event):void
		{
			this._acAtual = 'projeto recebido';
			this._telaMensagem.defineMensagem('<b>Chegou!</b><br />&nbsp;<br />O projeto de narrativa foi recebido! Use o botão "abrir projeto" para conferir.');
			try { this.stage.removeChild(ObjetoAprendizagem.compartilhamento); } catch (e:Error) { }
			try { this.removeChild(this._telaPrincipal); } catch (e:Error) { }
			this.addChild(this._telaMensagem);
		}
		
		/**
		 * Sucesso na importação de um projeto.
		 */
		private function onImportCancel(evt:Event):void
		{
			this._acAtual = 'projeto recebido';
			this._telaMensagem.defineMensagem('<b>Ops, alguma coisa deu errado...</b><br />&nbsp;<br />Não consegui importar o arquivo que recebi. Quer tentar mais uma vez?');
			try { this.stage.removeChild(ObjetoAprendizagem.compartilhamento); } catch (e:Error) { }
			try { this.removeChild(this._telaPrincipal); } catch (e:Error) { }
			this.addChild(this._telaMensagem);
		}
		
		/**
		 * Remoção do áudio confirmada.
		 */
		private function onRemoveSim(evt:Event):void
		{
			if (this._audioAtual != null) {
				if (Main.projeto.removeAudio(this._audioAtual.track, this._audioAtual.tempo)) {
					this._audioAtual.parent.removeChild(this._audioAtual);
					var encontrado:int = -1;
					for (var i:int = 0; i < this._elementos.length; i++) {
						if (this._elementos[i] == this._audioAtual) encontrado = i;
					}
					if (encontrado >= 0) this._elementos.splice(encontrado, 1);
					this._audioAtual.dispose();
				}
				this._audioAtual = null;
			}
		}
		
		/**
		 * Remoção do áudio negada.
		 */
		private function onRemoveNao(evt:Event):void
		{
			this._audioAtual = null;
		}
		
		/**
		 * Incluindo áudio a partir da biblioteca.
		 */
		private function onIncluiBiblioteca(evt:Event):void
		{
			this.removeChild(this._telaPrincipal);
			this.stage.addChild(this._telaBiblioteca);
		}
		
		/**
		 * Incluindo áudio próprio.
		 */
		private function onIncluiMeusAudios(evt:Event):void
		{
			this.salvar();
			this.removeChild(this._telaPrincipal);
			this._telaMeusAudios.pasta = Main.projeto.pasta.resolvePath('audios');
			this.stage.addChild(this._telaMeusAudios);
		}
		
		/**
		 * Inclusão a partir da biblioteca cancelada.
		 */
		private function onBibliotecaCancel(evt:Event):void
		{
			this._audioNova = null;
			this.addChild(this._telaPrincipal);
		}
		
		/**
		 * Inclusão a partir da biblioteca confirmada.
		 */
		private function onBibliotecaSelect(evt:Event):void
		{
			var selecionado:Object = this._telaBiblioteca.selecionado;
			if ((selecionado != null) && (this._audioNova != null)) {
				Main.projeto.adicionaAudio(this._audioNova.trilha, true, selecionado.arquivo, this._audioNova.tempo, selecionado.duracao, selecionado.titulo);
				this.desenhaTrilhas();
			}
			this._audioNova = null;
			this.addChild(this._telaPrincipal);
		}
		
		/**
		 * Inclusão a partir de meus áudios cancelada.
		 */
		private function onMeusAudiosCancel(evt:Event):void
		{
			this._audioNova = null;
			this.addChild(this._telaPrincipal);
		}
		
		/**
		 * Iniciar a gravação de áudio.
		 */
		private function onGravar(evt:Event):void
		{
			this._telaGravacao.pastaAudios = Main.projeto.pasta.resolvePath('audios');
			this.addChild(this._telaGravacao);
		}
		
		/**
		 * Inclusão a partir de meus áudios confirmada.
		 */
		private function onMeusAudiosSelect(evt:Event):void
		{
			var selecionado:Object = this._telaMeusAudios.selecionado;
			if ((selecionado != null) && (this._audioNova != null)) {
				Main.projeto.adicionaAudio(this._audioNova.trilha, false, selecionado.arquivo, this._audioNova.tempo, selecionado.duracao, selecionado.titulo);
				this.desenhaTrilhas();
			}
			this._audioNova = null;
			this.addChild(this._telaPrincipal);
		}
		
		/**
		 * A gravação de áudio foi cancelada.
		 */
		private function onGravacaoCancel(evt:Event):void
		{
			this.stage.addChild(this._telaMeusAudios);
		}
		
		/**
		 * A gravação de áudio foi concluída.
		 */
		private function onGravacaoComplete(evt:Event):void
		{
			this.stage.addChild(this._telaMeusAudios);
		}
		
		/**
		 * A tela de informações foi fechada.
		 */
		private function onInfoComplete(evt:Event):void
		{
			this.addChild(this._telaPrincipal);
		}
		
		/**
		 * O botão "informações" foi clicado.
		 */
		private function acInfo():void
		{
			this.removeChild(this._telaPrincipal);
			this.addChild(this._telaInfo);
		}
		
		/**
		 * O botão "abrir projeto" foi clicado.
		 */
		private function acAbrirPrjeto():void
		{
			if (this._telaEscolha.listar('Escolha um projeto para abrir ou apagar')) {
				this._acAtual = 'abrir projeto';
				this.removeChild(this._telaPrincipal);
				this.stage.addChild(this._telaEscolha);
				this._telaEscolha.mostrarLixeira();
			}
		}
		
		/**
		 * Clique no botão de ajuda.
		 */
		private function acAjuda():void
		{
			this.stage.addChild(this._telaAjuda);
		}
		
		/**
		 * O botão "exportar projeto" foi clicado.
		 */
		private function acExportarProjeto():void
		{
			if (this._telaEscolha.listar('Defina o projeto a exportar ou escolha um arquivo para importar')) {
				this._acAtual = 'exportar projeto';
				this.removeChild(this._telaPrincipal);
				this.stage.addChild(this._telaEscolha);
				this._telaEscolha.mostrarAbrir();
			}
		}
		
		/**
		 * O botão "novo projeto" foi clicado.
		 */
		private function acNovo():void
		{
			this._acAtual = 'novo projeto';
			this._telaMensagem.defineMensagem('<b>Uma nova narrativa?</b><br />&nbsp;<br />Você quer mesmo criar uma nova narrativa? Qualquer alteração não salva no seu projeto atual vai ser perdida.', true);
			this.addChild(this._telaMensagem);
			this.removeChild(this._telaPrincipal);
		}
		
		/**
		 * O botão "salvar" foi clicado.
		 */
		private function acSalvar():void
		{
			if (Main.projeto.titulo == '') {
				this._acAtual = 'aviso falta titulo';
				this._telaMensagem.defineMensagem('<b>Um probleminha...</b><br />&nbsp;<br />Sua narrativa ainda não tem um título e não posso gravá-la. Para dar um nome, toque no botão de informações.');
				this.addChild(this._telaMensagem);
				this.removeChild(this._telaPrincipal);
			} else if (Main.projeto.id == 'exemplo-kasai') {
				this._acAtual = 'aviso projeto exemplo';
				this._telaMensagem.defineMensagem('<b>Um probleminha...</b><br />&nbsp;<br />Alterações no projeto de exemplo não podem ser gravadas.');
				this.addChild(this._telaMensagem);
				this.removeChild(this._telaPrincipal);
			} else {
				this._acAtual = 'salvar projeto';
				this._telaMensagem.defineMensagem('<b>Quase lá!</b><br />&nbsp;<br />Você quer mesmo salvar sua narrativa com o nome <b>' + Main.projeto.titulo + '</b>?', true);
				this.addChild(this._telaMensagem);
				this.removeChild(this._telaPrincipal);
			}
		}
		
		/**
		 * O botão "compartilhar" foi clicado.
		 */
		private function acCompartilhar():void
		{
			if (Main.projeto.titulo == '') {
				this._acAtual = 'aviso falta titulo';
				this._telaMensagem.defineMensagem('<b>Oh, não!</b><br />&nbsp;<br />Sua narrativa ainda não tem um nome e não posso fazer o compartilhamento. Para dar um nome, toque no botão de informações.');
				this.addChild(this._telaMensagem);
				this.removeChild(this._telaPrincipal);
			} else {
				this._acAtual = 'compartilhar projeto';
				this._telaMensagem.defineMensagem('<b>Compartilhando...</b><br />&nbsp;<br />Você quer mesmo compartilhar sua narrativa com o nome <b>' + Main.projeto.titulo + '</b>?', true);
				this.addChild(this._telaMensagem);
				this.removeChild(this._telaPrincipal);
			}
		}
		
		/**
		 * O botão "receber projeto" foi clicado.
		 */
		private function acReceber():void {
			this._acAtual = 'receber projeto';
			this.removeChild(this._telaPrincipal);
			ObjetoAprendizagem.compartilhamento.iniciaLeitura();
			this.stage.addChild(ObjetoAprendizagem.compartilhamento);
		}
		
	}

}