package colabora.oaprendizagem.audionarrativa.display 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class AreaCheia extends Sprite
	{
		
		// VARIÁVEIS PRIVADAS
		
		private var _bgs:Vector.<Bitmap>;
		private var _tx:TextField;
		private var _tr:int;
		private var _dr:int;
		private var _tp:int;
		
		/**
		 * Construtor.
		 * @param	tr	trilha
		 * @param	dr	duração em segundos
		 * @param	tt	nome do áudio
		 * @param	tp	tempo onde o áudio foi incluído
		 */
		public function AreaCheia(tr:int, dr:int, tt:String, tp:int) 
		{
			this._tr = tr;
			this._dr = dr;
			this._tp = tp;
			this._bgs = new Vector.<Bitmap>();
			// adicionando blocos de acordo com a duração
			if (dr == 1) {
				// ocupa um único ponto
				this._bgs.push(Main.graficos.getGR('AreaCheia1'));
			} else if (dr == 2) {
				// ocupa dois pontos
				this._bgs.push(Main.graficos.getGR('AreaCheiaInicio'));
				this._bgs.push(Main.graficos.getGR('AreaCheiaFim'));
				this._bgs[1].x = AreaApp.BOXSIDE;
			} else {
				// ocupa vários pontos
				this._bgs.push(Main.graficos.getGR('AreaCheiaInicio'));
				for (var ponto:int = 1; ponto < (dr - 1); ponto++) {
					this._bgs.push(Main.graficos.getGR('AreaCheiaMeio'));
					this._bgs[ponto].x = ponto * AreaApp.BOXSIDE;
				}
				this._bgs.push(Main.graficos.getGR('AreaCheiaFim'));
				this._bgs[dr - 1].x = (dr - 1) * AreaApp.BOXSIDE;
			}
			for (var i:int = 0; i < this._bgs.length; i++) this.addChild(this._bgs[i]);
			
			// colorindo blocos
			switch (tr) {
				case 0: // vermelho
					this.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 200, 0, 0, 0);
					break;
				case 1: // verde
					this.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, 200, 0, 0);
					break;
				case 2: // azul
					this.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 200, 0);
					break;
			}
			
			// aplicando texto
			this._tx = new TextField();
			this._tx.width = this.width - 12;
			this._tx.height = 60;
			this._tx.x = 12;
			this._tx.y = 18;
			this._tx.selectable = false;
			this._tx.multiline = false;
			this._tx.wordWrap = false;
			this._tx.defaultTextFormat = new TextFormat('_sans', 40, 0xFFFFFF);
			this._tx.text = tt;
			this.addChild(this._tx);
			
			// posicionando
			this.x = AreaApp.BOXSIDE * tp;
			
			this.mouseChildren = false;
			
		}
		
		// VALORES SOMENTE LEITURA
		
		/**
		 * Trilha do áudio.
		 */
		public function get track():int { return (this._tr); }
		
		/**
		 * Duração do áudio.
		 */
		public function get duracao():int { return (this._dr); }
		
		/**
		 * Nome do áudio.
		 */
		public function get nome():String { return (this._tx.text); }
		
		/**
		 * Tempo de inclusão do áudio.
		 */
		public function get tempo():int { return (this._tp); }
		
		// FUNÇÕES PÚBLICAS
		
		/**
		 * Libera recursos usados por este objeto.
		 */
		public function dispose():void
		{
			this.removeChildren();
			while (this._bgs.length > 0) {
				this._bgs.shift().bitmapData.dispose();
			}
			this._bgs = null;
			this._tx = null;
		}
		
	}

}