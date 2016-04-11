package graphic 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class Graficos 
	{
		
		[Embed(source="AreaVazia.png")] 
		public var GRAreaVazia:Class;
		
		[Embed(source="AreaCheia1.png")] 
		public var GRAreaCheia1:Class;
		
		[Embed(source="AreaCheiaInicio.png")] 
		public var GRAreaCheiaInicio:Class;
		
		[Embed(source="AreaCheiaMeio.png")] 
		public var GRAreaCheiaMeio:Class;
		
		[Embed(source="AreaCheiaFim.png")] 
		public var GRAreaCheiaFim:Class;
		
		[Embed(source="FundoTrilhas.png")] 
		public var GRFundoTrilhas:Class;
		
		[Embed(source="BTAvancar.png")] 
		public var GRBTAvancar:Class;
		
		[Embed(source="BTAvancar10.png")] 
		public var GRBTAvancar10:Class;
		
		[Embed(source="BTVoltar.png")] 
		public var GRBTVoltar:Class;
		
		[Embed(source="BTVoltar10.png")] 
		public var GRBTVoltar10:Class;
		
		[Embed(source="BTInicio.png")] 
		public var GRBTInicio:Class;
		
		[Embed(source="BTPlay.png")] 
		public var GRBTPlay:Class;
		
		[Embed(source="BTPause.png")] 
		public var GRBTPause:Class;
		
		public function Graficos() 
		{
			
		}
		
		/**
		 * Recupera um bitmap com o gráfico indicado.
		 * @param	nome	o nome do gráfico a ser usado
		 * @return	objeto Bitmap com o gráfico ou null caso o nome não seja encontrado
		 */
		public function getGR(nome:String):Bitmap
		{
			var bmp:Bitmap;
			switch (nome) {
				case 'AreaVazia': bmp = new GRAreaVazia() as Bitmap; break;
				case 'AreaCheia1': bmp = new GRAreaCheia1() as Bitmap; break;
				case 'AreaCheiaInicio': bmp = new GRAreaCheiaInicio() as Bitmap; break;
				case 'AreaCheiaMeio': bmp = new GRAreaCheiaMeio() as Bitmap; break;
				case 'AreaCheiaFim': bmp = new GRAreaCheiaFim() as Bitmap; break;
				case 'FundoTrilhas': bmp = new GRFundoTrilhas() as Bitmap; break;
				case 'BTAvancar': bmp = new GRBTAvancar() as Bitmap; break;
				case 'BTAvancar10': bmp = new GRBTAvancar10() as Bitmap; break;
				case 'BTVoltar': bmp = new GRBTVoltar() as Bitmap; break;
				case 'BTVoltar10': bmp = new GRBTVoltar10() as Bitmap; break;
				case 'BTInicio': bmp = new GRBTInicio() as Bitmap; break;
				case 'BTPlay': bmp = new GRBTPlay() as Bitmap; break;
				case 'BTPause': bmp = new GRBTPause() as Bitmap; break;
			}
			if (bmp != null) bmp.smoothing = true;
			return (bmp);
		}
		
	}

}