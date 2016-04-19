package colabora.oaprendizagem.audionarrativa.display 
{
	import colabora.display.EscolhaProjeto;
	import colabora.display.TelaMensagem;
	import colabora.oaprendizagem.dados.ObjetoAprendizagem;
	import flash.display.Shape;
	import flash.display.Sprite;
	import colabora.oaprendizagem.audionarrativa.dados.AudioNarrativa;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
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
		private var _telaEscolha:EscolhaProjeto;
		private var _telaMensagem:TelaMensagem;
		
		private var _acoes:ActionArea;
		private var _acAtual:String = '';
		
		
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
			
			// botões de ação
			this._acoes = new ActionArea();
			this._acoes.y = this._telaPrincipal.height + ((AreaApp.AREAHEIGHT - this._telaPrincipal.height - this._acoes.height) / 2);
			this._telaPrincipal.addChild(this._acoes);
			this._acoes.acAbrir = this.acAbrirPrjeto;
			this._acoes.acArquivos = this.acExportarProjeto;
			this._acoes.acNovo = this.acNovo;
			this._acoes.acSalvar = this.acSalvar;
			this._acoes.acCompartilhar = this.acCompartilhar;
			this._acoes.acReceber = this.acReceber;
			
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
													File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/projetos/' ));
			this._telaEscolha.addEventListener(Event.COMPLETE, onEscolhaOK);
			this._telaEscolha.addEventListener(Event.CANCEL, onEscolhaCancel);
			
			// tela de mensagens
			this._telaMensagem = new TelaMensagem(Main.graficos.getSPGR('BTOk'),
													Main.graficos.getSPGR('BTCancel'),
													0x666666, 
													0xFFFFFF);
			this._telaMensagem.addEventListener(Event.COMPLETE, onMensagemOK);
			this._telaMensagem.addEventListener(Event.CANCEL, onMensagemCancel);
			
			// tela de compartilhamento
			ObjetoAprendizagem.compartilhamento.addEventListener(Event.CLOSE, onCompartilhamentoClose);
			ObjetoAprendizagem.compartilhamento.addEventListener(Event.COMPLETE, onCompartilhamentoComplete);
			
			// importação de projetos
			Main.projeto.addEventListener(Event.CANCEL, onImportCancel);
			Main.projeto.addEventListener(Event.COMPLETE, onImportComplete);
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
		
		/**
		 * Clique em uma área vazia nas trilhas.
		 */
		private function cliqueVazia(evt:MouseEvent):void
		{
			var clicada:AreaVazia = evt.target as AreaVazia;
			trace ('clique em', clicada.trilha, clicada.tempo);
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
							Main.projeto.salvar();
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
						this._telaMensagem.defineMensagem('<b>Erro!</b><br />&nbsp;<br />Não foi possível abrir o projeto escolhido. Por favor tente novamente.');
						this.stage.addChild(this._telaMensagem);
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
						this._telaMensagem.defineMensagem('<b>Erro!</b><br />&nbsp;<br />Não foi possível exportar o projeto escolhido. Por favor tente novamente.');
						this.stage.addChild(this._telaMensagem);
					} else {
						// avisar sobre o projeto exportado
						this.stage.removeChild(this._telaEscolha);
						this._telaMensagem.defineMensagem('<b>Exportação concluída</b><br />&nbsp;<br />O projeto selecionado foi exportado e está gravado com o nome <br />&nbsp;<br /><b>' + exportado + '</b><br />&nbsp;<br />na pasta <br />&nbsp;<br /><b>' + File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/exportados').nativePath + '</b><br />&nbsp;<br />de seu aparelho.');
						this.stage.addChild(this._telaMensagem);
					}
					break;
				default:
					this.stage.removeChild(this._telaEscolha);
					this.addChild(this._telaPrincipal);
					break;
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
					this.stage.removeChild(this._telaMensagem);
					this.addChild(this._telaPrincipal);
					break;
				case 'salvar projeto':
					Main.projeto.salvar();
					this.stage.removeChild(this._telaMensagem);
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
						this._telaMensagem.defineMensagem('<b>Erro!</b><br />&nbsp;<br />Não foi possível exportar o projeto escolhido para compartilhamento. Por favor tente novamente.');
					} else {
						// iniciar compartilhamento
						if (ObjetoAprendizagem.compartilhamento.iniciaURL(File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/exportados/' + exportado))) {
							this.stage.removeChild(this._telaMensagem);
							this.stage.addChild(ObjetoAprendizagem.compartilhamento);
						} else {
							// avisar sobre erro de compartilhamento
							this._acAtual = 'erro compartilhando projeto';
							this._telaMensagem.defineMensagem('<b>Erro!</b><br />&nbsp;<br />Não foi possível exportar o projeto escolhido para compartilhamento. Por favor tente novamente.');
						}
					}
					break;
				default:
					this.stage.removeChild(this._telaMensagem);
					this.addChild(this._telaPrincipal);
					break;
			}
			
		}
		
		/**
		 * O botão cancelar foi escolhido na tela de mensagens.
		 */
		private function onMensagemCancel(evt:Event):void
		{
			this.stage.removeChild(this._telaMensagem);
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
				this._telaMensagem.defineMensagem('<b>Erro de importação!</b><br />&nbsp;<br />Não foi possível importar o projeto recebido. Por favor tente novamente.');
				this.stage.removeChild(ObjetoAprendizagem.compartilhamento);
				this.stage.addChild(this._telaMensagem);
			}
		}
		
		/**
		 * Falha na importação de um projeto.
		 */
		private function onImportComplete(evt:Event):void
		{
			this._acAtual = 'projeto recebido';
			this._telaMensagem.defineMensagem('<b>Projeto importado!</b><br />&nbsp;<br />O projeto recebido foi importado corretamente. Use o botão "abrir projeto" para conferi-lo.');
			try { this.stage.removeChild(ObjetoAprendizagem.compartilhamento); } catch (e:Error) { }
			try { this.removeChild(this._telaPrincipal); } catch (e:Error) { }
			this.stage.addChild(this._telaMensagem);
		}
		
		/**
		 * Sucesso na importação de um projeto.
		 */
		private function onImportCancel(evt:Event):void
		{
			this._acAtual = 'projeto recebido';
			this._telaMensagem.defineMensagem('<b>Erro de importação!</b><br />&nbsp;<br />Não foi possível importar o projeto recebido. Por favor tente novamente.');
			try { this.stage.removeChild(ObjetoAprendizagem.compartilhamento); } catch (e:Error) { }
			try { this.removeChild(this._telaPrincipal); } catch (e:Error) { }
			this.stage.addChild(this._telaMensagem);
		}
		
		/**
		 * O botão "abrir projeto" foi clicado.
		 */
		private function acAbrirPrjeto():void
		{
			if (this._telaEscolha.listar('Escolha o projeto a abrir')) {
				this._acAtual = 'abrir projeto';
				this.removeChild(this._telaPrincipal);
				this.stage.addChild(this._telaEscolha);
			}
		}
		
		/**
		 * O botão "exportar projeto" foi clicado.
		 */
		private function acExportarProjeto():void
		{
			if (this._telaEscolha.listar('Escolha o projeto para exportar')) {
				this._acAtual = 'exportar projeto';
				this.removeChild(this._telaPrincipal);
				this.stage.addChild(this._telaEscolha);
			}
		}
		
		/**
		 * O botão "novo projeto" foi clicado.
		 */
		private function acNovo():void
		{
			this._acAtual = 'novo projeto';
			this._telaMensagem.defineMensagem('<b>Atenção!</b><br />&nbsp;<br />Você quer realmente criar um projeto novo? Alterações não gravadas no projeto atual serão perdidas!', true);
			this.stage.addChild(this._telaMensagem);
			this.removeChild(this._telaPrincipal);
		}
		
		/**
		 * O botão "salvar" foi clicado.
		 */
		private function acSalvar():void
		{
			if (Main.projeto.titulo == '') {
				this._acAtual = 'aviso falta titulo';
				this._telaMensagem.defineMensagem('<b>Atenção!</b><br />&nbsp;<br />Seu projeto ainda não tem um título e não pode ser gravado. Toque no botão de informações para incluir um título e tente novamente.');
				this.stage.addChild(this._telaMensagem);
				this.removeChild(this._telaPrincipal);
			} else {
				this._acAtual = 'salvar projeto';
				this._telaMensagem.defineMensagem('<b>Atenção!</b><br />&nbsp;<br />Você tem certeza de que quer salvar o projeto atual com o título <b>' + Main.projeto.titulo + '</b>?', true);
				this.stage.addChild(this._telaMensagem);
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
				this._telaMensagem.defineMensagem('<b>Atenção!</b><br />&nbsp;<br />Seu projeto ainda não tem um título e não pode ser compartilhado. Toque no botão de informações para incluir um título e tente novamente.');
				this.stage.addChild(this._telaMensagem);
				this.removeChild(this._telaPrincipal);
			} else {
				this._acAtual = 'compartilhar projeto';
				this._telaMensagem.defineMensagem('<b>Atenção!</b><br />&nbsp;<br />Você tem certeza de que quer compartilhar o projeto atual com o título <b>' + Main.projeto.titulo + '</b>?', true);
				this.stage.addChild(this._telaMensagem);
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