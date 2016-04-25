package colabora.oaprendizagem.audionarrativa.display 
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class TelaBiblioteca extends TelaListaAudios
	{
		
		// VARIÁVEIS PRIVADAS
		
		private var _htmlBiblioteca:String;
		
		public function TelaBiblioteca() 
		{
			// carregando informações da biblioteca
			var stream:FileStream = new FileStream();
			stream.open(File.applicationDirectory.resolvePath('biblioteca.html'), FileMode.READ);
			this._htmlBiblioteca = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			
			// pasta da biblioteca
			this._pasta = File.applicationDirectory.resolvePath('biblioteca/');
		}
		
		// VALORES SOMENTE LEITURA
		
		/**
		 * Listagem de arquivos da biblioteca em HTML.
		 */
		override protected function get conteudoHtml():String 
		{
			return (this._htmlBiblioteca);
		}
		
	}

}