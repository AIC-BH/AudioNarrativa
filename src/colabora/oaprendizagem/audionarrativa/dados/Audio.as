package colabora.oaprendizagem.audionarrativa.dados 
{
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class Audio 
	{
		
		/**
		 * Trilha onde o áudio aparece.
		 */
		public var trilha:int = -1;
		
		/**
		 * Áudio faz parte da biblioteca?
		 */
		public var biblioteca:Boolean = true;
		
		/**
		 * Nome do arquivo de áudio.
		 */
		public var nome:String = '';
		
		/**
		 * Título do áudio.
		 */
		public var titulo:String = '';
		
		/**
		 * Duração do áudio.
		 */
		public var duracao:int = 1;
		
		/**
		 * Posição do áudio no vetor de áudios da trilha.
		 */
		public var posicao:int = -1;
		
		/**
		 * Tempo em que o áudio deve ser tocado.
		 */
		public var tempo:int = -1;
		
		public function Audio(tr:int, bb:Boolean, nm:String, tp:int, dr:int, tt:String) 
		{
			// recuperando informações do áudio
			this.trilha = tr;
			this.biblioteca = bb;
			this.nome = nm;
			this.tempo = tp;
			this.duracao = dr;
			this.titulo = tt;
		}
		
		/**
		 * Objeto de dados deste áudio para arquivamento.
		 */
		public function get dados():Object
		{
			var data:Object = new Object();
			data.trilha = this.trilha;
			data.biblioteca = this.biblioteca;
			data.nome = this.nome;
			data.tempo = this.tempo;
			data.duracao = this.duracao;
			data.titulo = this.titulo;
			return(data);
		}
		
		/**
		 * Libera recursos usados por este objeto.
		 */
		public function dispose():void
		{
			this.nome = null;
		}
		
	}

}