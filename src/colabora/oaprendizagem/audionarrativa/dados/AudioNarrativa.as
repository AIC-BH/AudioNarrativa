package colabora.oaprendizagem.audionarrativa.dados 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import colabora.oaprendizagem.dados.ObjetoAprendizagem;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class AudioNarrativa extends EventDispatcher
	{
		// CONSTANTES
		
		/**
		 * Número de trilhas de áudio disponíveis.
		 */
		public static const NUMTRILHAS:int = 3;
		
		/**
		 * Duração máxima de uma narrativa, em segundos.
		 */
		public static const MAXTIME:int = 300;
		
		/**
		 * Identificador único desta narrativa.
		 */
		public var id:String;
		
		/**
		 * Título desta narrativa.
		 */
		public var titulo:String;
		
		/**
		 * Tags associadas a esta narrativa.
		 */
		public var tags:String;
		
		/**
		 * Referência para a pasta de gravação do projeto.
		 */
		public var pasta:File;
		
		/**
		 * Trilha de áudios.
		 */
		public var trilha:Vector.<Trilha>;
		
		// VARIÁVEIS PRIVADAS
		
		private var _tempo:int = 0;				// tempo atual
		private var _intervalo:int = -1;		// intervalo da função tocar
		
		public function AudioNarrativa() 
		{
			// criando id
			this.id = String(new Date().getTime());
			// título e tags
			this.titulo = '';
			this.tags = '';
			// direcionando pasta de gravação
			this.pasta = File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/projetos/' + this.id);
			var pastaBiblioteca:File = File.applicationDirectory.resolvePath('biblioteca');
			var pastaAudios:File = this.pasta.resolvePath('audios');
			// criando as trilhas de áudio
			this.trilha = new Vector.<Trilha>();
			for (var i:int = 0; i < AudioNarrativa.NUMTRILHAS; i++) {
				this.trilha.push(new Trilha(i));
				this.trilha[i].pastaBiblioteca = pastaBiblioteca;
				this.trilha[i].pastaAudios = pastaAudios;
			}
		}
		
		/**
		 * Objeto de dados desta trilha para arquivamento.
		 */
		public function get dados():Object
		{
			var data:Object = new Object();
			data.id = this.id;
			data.titulo = this.titulo;
			data.tags = this.tags;
			data.trilha = new Array();
			for (var i:int = 0; i < this.trilha.length; i++) {
				data.trilha.push(this.trilha[i].dados);
			}
			return (data);
		}
		
		/**
		 * O tempo atual do áudio.
		 */
		public function get tempoAtual():int
		{
			return (this._tempo);
		}
		public function set tempoAtual(to:int):void
		{
			if ((to >= 0) && (to < AudioNarrativa.MAXTIME)) {
				// tempo dentro do limite
				this._tempo = to;
			}
		}
		
		/**
		 * Carrega informações de um projeto de narrativa de áudio.
		 * @param	id	identificador da narrativa a carregar
		 * @return	TRUE se a narrativa existir na pasta de documentos e seus arquivos estiverem corretos
		 */
		public function carregaProjeto(id:String):Boolean
		{
			// verificando a existência do projeto
			var arquivoProj:File = File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/projetos/' + id + '/projeto.json');
			if (arquivoProj.exists) {
				// recuperando texto do arquivo
				var stream:FileStream = new FileStream();
				stream.open(arquivoProj, FileMode.READ);
				var jsonTXT:String = stream.readUTFBytes(stream.bytesAvailable);
				stream.close();
				// fazendo a leitura do arquivo
				var lido:Boolean = false;
				var dados:Object;
				try {
					// recuperando objeto de dados
					dados = JSON.parse(jsonTXT);
					lido = true;
				} catch (e:Error) {
					// o texto não contém um JSON válido
					lido = false;
				}
				// dados recuperados?
				if (lido) {
					if ((dados.id != null) && (dados.trilha != null) && (dados.titulo != null) && (dados.tags != null)) {
						// limpando informações anteriores
						this.clear();
						// atribuindo id, título e tags
						this.id = dados.id;
						this.titulo = dados.titulo;
						this.tags = dados.tags;
						// direcionando pasta de gravação
						this.pasta = File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/projetos/' + this.id);
						var pastaAudios:File = this.pasta.resolvePath('audios');
						// carregando trilhas
						for (var i:int = 0; i < dados.trilha.length; i++) {
							this.trilha[dados.trilha[i].id].carregaDados(dados.trilha[i]);
							this.trilha[dados.trilha[i].id].pastaAudios = pastaAudios;
						}
						// projeto carregado
						return (true);
					} else {
						// o objeto recuperado não traz os campos de um projeto
						return (false);
					}
				} else {
					// o arquivo não contém dados de um projeto
					return (false);
				}
			} else {
				// o projeto indicado não existe
				return (false);
			}
		}
		
		/**
		 * Adiciona informações sobre um áudio a uma trilha.
		 * @param	tr	trilha (0 a NUMTRILHAS -1)
		 * @param	bb	o áudio vem da biblioteca?
		 * @param	nm	nome do arquivo de áudio
		 * @param	tp	o tempo da inclusão do áudio
		 * @param	dr	a duração do áudio
		 * @param	tt	título do áudio
		 */
		public function adicionaAudio(tr:int, bb:Boolean, nm:String, tp:int, dr:int, tt:String):void
		{
			if ((tr >= 0) && (tr <= (AudioNarrativa.NUMTRILHAS - 1))) {
				this.trilha[tr].adicionaAudio(bb, nm, tp, dr, tt);
			}
		}
		
		/**
		 * Define um novo id para o projeto atual.
		 * @param	novoID	o novo id
		 * @param	renomear	renomear a pasta já existente com o id atual para o novo?
		 */
		public function defineID(novoID:String, renomear:Boolean = false):void
		{
			// referência para a pasta com o novo id
			var novaPasta:File = File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/projetos/' + novoID);
			// renomear a pasta existente com o novo id?
			if (renomear) {
				this.pasta.moveTo(novaPasta);
			}
			// atribuir o novo id
			this.id = novoID;
			this.pasta = novaPasta;
			// nova pasta? é preciso gravar o projeto
			if (renomear) {
				this.salvar();
			}
		}
		
		/**
		 * Começa tocar a narrativa de áudio.
		 * @param	tempo	tempo de início em segundos (< 0 para tocar do tempo atual)
		 * @return	TRUE se o tempo indicado está dentro do limite da narrativa e o áudio começou a ser tocado
		 */
		public function play(tempo:int = -1):Boolean
		{
			// usar tempo atual?
			if (tempo < 0) tempo = this._tempo;
			// o tempo indicado pode ser tocado?
			if (this.tocarTempo(tempo)) {
				// verificar novos áudios a cada segundo
				if (this._intervalo >= 0) try { clearInterval(this._intervalo); } catch (e:Error) { } 
				this._intervalo = setInterval(proximoSegundo, 1000);
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Parando de tocar todos os áudios e voltando para o início.
		 */
		public function stop():void
		{
			try { clearInterval(this._intervalo); } catch (e:Error) { }
			this._tempo = 0;
			for (var i:int = 0; i < AudioNarrativa.NUMTRILHAS; i++) this.trilha[i].stop();
		}
		
		/**
		 * Parando de tocar todos os áudios.
		 */
		public function pause():void
		{
			try { clearInterval(this._intervalo); } catch (e:Error) { }
			for (var i:int = 0; i < AudioNarrativa.NUMTRILHAS; i++) this.trilha[i].stop();
		}
		
		/**
		 * Salvando informações sobre o projeto de narrativa de áudio.
		 */
		public function salvar():void
		{
			// a pasta de gravação existe?
			if (!this.pasta.isDirectory) this.pasta.createDirectory();
			// a pasta de áudios próprios do projeto existe?
			if (!this.pasta.resolvePath('audios').isDirectory) this.pasta.resolvePath('audios').createDirectory();
			// salvando dados do projeto
			var stream:FileStream = new FileStream();
			stream.open(this.pasta.resolvePath('projeto.json'), FileMode.WRITE);
			stream.writeUTFBytes(JSON.stringify(this.dados));
			stream.close();
		}
		
		/**
		 * Limpa informações deste objeto.
		 */
		public function clear():void
		{
			// recriando id
			this.id = String(new Date().getTime());
			// título e tags
			this.titulo = '';
			this.tags = '';
			// direcionando pasta de gravação
			this.pasta = File.documentsDirectory.resolvePath(ObjetoAprendizagem.codigo + '/projetos/' + this.id);
			var pastaAudios:File = this.pasta.resolvePath('audios');
			// limpando trilhas
			for (var i:int = 0; i < AudioNarrativa.NUMTRILHAS; i++) {
				this.trilha[i].clear();
				this.trilha[i].pastaAudios = pastaAudios;
			}
		}
		
		/**
		 * Libera recursos usados por este objeto.
		 */
		public function dispose():void
		{
			while (this.trilha.length > 0) this.trilha.shift().dispose();
			this.trilha = null;
			this.id = null;
			this.titulo = null;
			this.tags = null;
		}
		
		// FUNÇÕES PRIVADAS
		
		/**
		 * Tocar os áudios referentes ao tempo indicado.
		 * @param	tempo	tempo, em segundos
		 * @return	TRUE se o tempo está dentro do limite máximo
		 */
		private function tocarTempo(tempo:int):Boolean
		{
			if ((tempo >= 0) && (tempo < AudioNarrativa.MAXTIME)) {
				// tempo dentro do limite
				this._tempo = tempo;
				for (var i:int = 0; i < AudioNarrativa.NUMTRILHAS; i++) this.trilha[i].tocar(tempo);
				return (true);
			} else {
				// tempo fora do limite máximo
				return (false);
			}
		}
		
		/**
		 * Verifica o próximo segundo de áudio.
		 */
		private function proximoSegundo():void
		{
			this._tempo++;
			if (this._tempo >= AudioNarrativa.MAXTIME) {
				// tempo máximo atingido
				this._tempo = 0;
				try { clearInterval(this._intervalo); } catch (e:Error) { }
				this._intervalo = -1;
				this.dispatchEvent(new Event(Event.SOUND_COMPLETE));
			} else {
				// tocar áudio atual
				this.tocarTempo(this._tempo);
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
	}

}