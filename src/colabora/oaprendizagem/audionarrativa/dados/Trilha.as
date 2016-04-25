package colabora.oaprendizagem.audionarrativa.dados 
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class Trilha 
	{
		/**
		 * Número desta trilha.
		 */
		public var id:int = -1;
		
		/**
		 * Áudios registrados para esta trilha.
		 */
		public var audio:Vector.<Audio>;
		
		/**
		 * Volume do áudio do canal, de 0 a 1.
		 */
		public var volume:Number = 1;
		
		/**
		 * Referência da pasta de armazenamento de áudios do projeto.
		 */
		public var pastaAudios:File;
		
		/**
		 * Referência da pasta de armazenamento de áudios da biblioteca.
		 */
		public var pastaBiblioteca:File;
		
		// VARIÁVEIS PRIVADAS
		
		private var _sound:Sound;				// arquivo de som
		private var _channel:SoundChannel;		// canal de som
		
		public function Trilha(num:int) 
		{
			this.audio = new Vector.<Audio>();
			this.id = num;
			// preparando o objeto de som
			this._sound = new Sound();
			this._sound.addEventListener(Event.COMPLETE, somCarregado);
		}
		
		/**
		 * Objeto de dados desta trilha para arquivamento.
		 */
		public function get dados():Object
		{
			var data:Object = new Object();
			data.id = this.id;
			data.audio = new Array();
			data.volume = this.volume;
			for (var i:int = 0; i < this.audio.length; i++) {
				data.audio.push(this.audio[i].dados);
			}
			return (data);
		}
		
		/**
		 * Carrega informações da trilha a partir de um objeto de dados.
		 * @param	dados	dados a serem carregados
		 */
		public function carregaDados(dados:Object):void
		{
			// limpando informações anteriores
			this.clear();
			// carrgando informações
			if (dados.audio != null) {
				for (var i:int = 0; i < dados.audio.length; i++) {
					this.audio.push(new Audio(this.id, dados.audio[i].biblioteca, dados.audio[i].nome, dados.audio[i].tempo, dados.audio[i].duracao, dados.audio[i].titulo));
				}
				this.acertaVAudios();
			}
			// volume
			this.volume = dados.volume;
		}
		
		/**
		 * Adiciona informações sobre um áudio na trilha.
		 * @param	bb	o áudio vem da biblioteca?
		 * @param	nm	nome do arquivo de áudio
		 * @param	tp	o tempo da inclusão do áudio
		 * @param	dr	a duração do áudio
		 * @param	tt	título do áudio
		 */
		public function adicionaAudio(bb:Boolean, nm:String, tp:int, dr:int, tt:String):void
		{
			if (this.audio.length == 0) {
				// primeiro áudio inserido na trilha
				this.audio.push(new Audio(this.id, bb, nm, tp, dr, tt));
			} else {
				// já há algum áudio no tempo indicado? remover!
				var indice:int = -1
				for (var i:int = 0; i < this.audio.length; i++) {
					if (this.audio[i].tempo == tp) indice = i;
				}
				if (indice >= 0) {
					// substituir o áudio atual pelo novo
					this.audio.splice(indice, 1, new Audio(this.id, bb, nm, tp, dr, tt))[0].dispose();
				} else {
					// verificando vetor para a posição certa do áudio
					indice = -1;
					for (i = 0; i < this.audio.length; i++) {
						if (indice < 0) {
							if (this.audio[i].tempo > tp) {
								indice = i;
							}
						}
					}
					// inserindo áudio na posição correta
					if (indice < 0) {
						// o tempo é maior que o dos outros áudios: inserir no final do vetor
						this.audio.push(new Audio(this.id, bb, nm, tp, dr, tt));
					} else {
						// inserir o áudio na posição do primeiro com tempo maior, arrastando todos os seguintes um índice para cima
						this.audio.splice(indice, 0, new Audio(this.id, bb, nm, tp, dr, tt));
					}
				}
			}
			// acertando posições de áudios
			this.acertaVAudios();
		}
		
		/**
		 * Remove um áudio registrado.
		 * @param	tp	o tempo em que o áudio está colocado
		 * @return	TRUE se um áudio for encontrado no tempo definido e puder ser removido
		 */
		public function removeAudio(tp:int):Boolean
		{
			var encontrado:int = -1;
			for (var i:int = 0; i < this.audio.length; i++) {
				if (this.audio[i].tempo == tp) encontrado = i;
			}
			if (encontrado >= 0) {
				this.audio[encontrado].dispose();
				this.audio.splice(encontrado, 1);
				this.acertaVAudios();
				return (true);
			} else {
				return (false);
			}
		}
		
		/**
		 * Acerta os valores de posição dos audios de acordo com o vetor de informações.
		 */
		public function acertaVAudios():void
		{
			for (var i:int = 0; i < this.audio.length; i++) {
				this.audio[i].posicao = i;
			}
		}
		
		/**
		 * Verifica o áudio registrado para o tempo indicado.
		 * @param	tempo	o tempo a conferir
		 * @return	vetor de índices de áudios encontrados: caso não exista áudio para o tempo, um vetor vazio. caso exista áudio e ele seja o último da trilha, um vetor com apenas o ídice. caso exista um áudio para um tempo posterior, o vetor incorpora também o indice deste aúdio.
		 *
		public function audioPara(tempo:int):Vector.<int>
		{
			var indice:int = -1;
			for (var i:int = 0; i < this.audio.length; i++) {
				if (this.audio[i].tempo == tempo) indice = i;
			}
			var retorno:Vector.<int> = new Vector.<int>();
			if (indice >= 0) {
				retorno.push(indice);
				if (this.audio.length >= indice) retorno.push(indice + 1);
			}
			return (retorno);
		}
		*/
		
		/**
		 * Toca o áudio registrado para o tempo indicado.
		 * @param	tempo	o tempo a conferir em segundos
		 * @return	TRUE caso exista um áudio para o tempo indicado
		 */
		public function tocar(tempo:int):Boolean
		{
			var indice:int = -1;
			for (var i:int = 0; i < this.audio.length; i++) {
				if (this.audio[i].tempo == tempo) indice = i;
			}
			
			if (indice < 0) {
				// não há áudio registrado para o tempo atual
				return (false);
			} else {
				// abrir o som
				var som:File;
				if (this.audio[indice].biblioteca) {
					// carregar da biblioteca
					som = this.pastaBiblioteca.resolvePath(this.audio[indice].nome);
				} else {
					// cerregar da pasta do projeto
					som = this.pastaAudios.resolvePath(this.audio[indice].nome);
				}
				// tocar áudio
				if (som.exists) {
					// carregar arquivo
					if (this._sound != null) {
						// há algum som anterior? removendo
						try { this._sound.close(); } catch (e:Error) { }
						this._sound.removeEventListener(Event.COMPLETE, somCarregado);
						this._sound = null;
					}
					// abrindo arquivo
					this._sound = new Sound();
					this._sound.addEventListener(Event.COMPLETE, somCarregado);
					this._sound.load(new URLRequest(som.url));
					return (true);
				} else {
					// o arquivo de áudio não foi encontrado
					return (false);
				}
			}
		}
		
		/**
		 * Parando a execução de um áudio.
		 */
		public function stop():void
		{
			this.canalCompleto();
		}
		
		/**
		 * Limpando informações sobre este objeto.
		 */
		public function clear():void
		{
			while (this.audio.length > 0) this.audio.shift().dispose();
			if (this._channel != null) {
				this._channel.removeEventListener(Event.SOUND_COMPLETE, canalCompleto);
				this._channel.stop();
			}
			this.volume = 1;
		}
		
		/**
		 * Libera recursos usados por este objeto.
		 */
		public function dispose():void
		{
			while (this.audio.length > 0) this.audio.shift().dispose();
			this.audio = null;
			this.pastaAudios = null;
			this.pastaBiblioteca = null;
			this._sound.removeEventListener(Event.COMPLETE, somCarregado);
			this._sound = null;
			this.canalCompleto();
		}
		
		// FUNÇÕES PRIVADAS
		
		/**
		 * Um arquivo de som foi carregado: tocar.
		 */
		private function somCarregado(evt:Event):void
		{
			// criando um canal de som para o áudio carregado
			this.canalCompleto();
			this._channel = this._sound.play();
			this._channel.addEventListener(Event.SOUND_COMPLETE, canalCompleto);
			// verificando volume
			if (this.volume < 0) this.volume = 0;
			if (this.volume > 1) this.volume = 1;
			this._channel.soundTransform = new SoundTransform(this.volume);
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
		}
		
	}

}