package colabora.oaprendizagem.audionarrativa.display 
{
	import com.adobe.audio.format.WAVWriter;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SampleDataEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.media.Microphone;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import fr.kikko.lab.ShineMP3Encoder;
	/**
	 * ...
	 * @author Lucas S. Junqueira
	 */
	public class TelaGravacao extends Sprite
	{
		
		// VARIÁVEIS PÚBLICAS
		
		public var pastaAudios:File;
		
		// VARIÁVEIS PRIVADAS
		
		private var _bg:Shape;
		private var _bgTextArea:Bitmap;
		private var _btcancel:Sprite;
		private var _btok:Sprite;
		private var _btplay:Sprite;
		private var _btstop:Sprite;
		private var _btmicrofone:Sprite;
		private var _mainControls:Sprite;
		private var _titulo:TextField;
		private var _msgGravando:Sprite;
		private var _msgProcessando:Bitmap;
		
		private var _mic:Microphone;
		private var _soundRecording:ByteArray;
		private var _tempFile:File;
		private var _mp3Encoder:ShineMP3Encoder;
		private var _sound:Sound;
		private var _channel:SoundChannel;
		
		public function TelaGravacao(w:Number, h:Number) 
		{
			// fundo
			this._bg = new Shape();
			this._bg.graphics.beginFill(0x333333);
			this._bg.graphics.drawRect(0, 0, w, h);
			this._bg.graphics.endFill();
			
			// tela de controles principais
			this._mainControls = new Sprite();
			
			// fundo do campo de texto
			this._bgTextArea = Main.graficos.getGR('AreaTextoNome');
			this._mainControls.addChild(this._bgTextArea);
			
			// botões ok/cancel
			this._btcancel = Main.graficos.getSPGR('BTCancel');
			this._btcancel.addEventListener(MouseEvent.CLICK, onCancel);
			this._mainControls.addChild(this._btcancel);
			this._btok = Main.graficos.getSPGR('BTOk');
			this._btok.addEventListener(MouseEvent.CLICK, onOk);
			this._mainControls.addChild(this._btok);
			
			// botões play/stop
			this._btplay = Main.graficos.getSPGR('BTPlay');
			this._btplay.addEventListener(MouseEvent.CLICK, onPlay);
			this._mainControls.addChild(this._btplay);
			this._btstop = Main.graficos.getSPGR('BTStop');
			this._btstop.addEventListener(MouseEvent.CLICK, onStop);
			this._mainControls.addChild(this._btstop);
			
			// botão gravar
			this._btmicrofone = Main.graficos.getSPGR('BTMicrofoneGrande');
			this._btmicrofone.addEventListener(MouseEvent.CLICK, onMicrofone);
			this._mainControls.addChild(this._btmicrofone);
			
			// título
			this._titulo = new TextField();
			this._titulo.defaultTextFormat = new TextFormat('_sans', 40, 0);
			this._titulo.multiline = false;
			this._titulo.wordWrap = false;
			this._titulo.type = TextFieldType.INPUT;
			this._titulo.needsSoftKeyboard = true;
			this._mainControls.addChild(this._titulo);
			
			// mensagens
			this._msgGravando = Main.graficos.getSPGR('MensagemGravandoAudio');
			this._msgGravando.addEventListener(MouseEvent.CLICK, onFimGravacao);
			this._msgProcessando = Main.graficos.getGR('MensagemProcessandoAudio');
			
			// verificando tela
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onNoStage);
		}
		
		// FUNÇÕES PRIVADAS
		
		/**
		 * Adicionado à tela.
		 */
		private function onStage(evt:Event):void
		{			
			// calculando espaços verticais
			var intervalo:Number = (this._bg.height - (this._bgTextArea.height + this._btmicrofone.height + this._btcancel.height)) / 4;
			
			// posicionando elementos
			this._bgTextArea.x = (this._bg.width - this._bgTextArea.width) / 2;
			this._bgTextArea.y = intervalo;
			this._btmicrofone.x = (this._bg.width - this._btmicrofone.width) / 2;
			this._btmicrofone.y = this._bgTextArea.y + this._bgTextArea.height + intervalo;
			this._btplay.x = this._btstop.x = (this._bg.width - this._btplay.width) / 2;
			this._btplay.y = this._btstop.y = this._btmicrofone.y + this._btmicrofone.height + intervalo;
			this._btcancel.x = this._btplay.x - 64 - this._btcancel.width;
			this._btcancel.y = this._btplay.y;
			this._btok.x = this._btplay.x + this._btplay.width + 64;
			this._btok.y = this._btplay.y;
			
			// título
			this._titulo.x = this._bgTextArea.x + 140;
			this._titulo.y = this._bgTextArea.y + 35;
			this._titulo.width = 740;
			this._titulo.height = 80;
			
			// mensagens
			this._msgGravando.x = (this._bg.width - this._msgGravando.width) / 2;
			this._msgGravando.y = (this._bg.height - this._msgGravando.height) / 2;
			this._msgProcessando.x = (this._bg.width - this._msgProcessando.width) / 2;
			this._msgProcessando.y = (this._bg.height - this._msgProcessando.height) / 2;
			
			// começando a gravar
			this.iniciaGravacao();
		}
		
		/**
		 * Removido da tela.
		 */
		private function onNoStage(evt:Event):void
		{
			this.canalCompleto();
			this.removeChildren();
		}
		
		/**
		 * Clique no botão cancel.
		 */
		private function onCancel(evt:MouseEvent):void
		{
			parent.removeChild(this);
			this.dispatchEvent(new Event(Event.CANCEL));
		}
		
		/**
		 * Clique no botão ok.
		 */
		private function onOk(evt:MouseEvent):void
		{
			if ((this._sound != null) && (this._tempFile != null) && (this._tempFile.exists)) {
				// ajustando título
				var titulo:String = novoTitulo();
				var regExp:RegExp=/[:|\/|.|&|$|#|*|+|=|<|>|\\|@|%]/g;
				if (this._titulo.text != '') titulo = this._titulo.text.replace(regExp, '');
				if (titulo == '') titulo = novoTitulo();
				titulo = titulo.split('.mp3').join('') + '.mp3';
				
				// copiando arquivo
				this._tempFile.moveTo(this.pastaAudios.resolvePath(titulo), true);
				
				// fechando tela de gravação
				parent.removeChild(this);
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		/**
		 * Clique no botão play.
		 */
		private function onPlay(evt:MouseEvent):void
		{
			if (this._sound != null) {
				this.canalCompleto();
				this._channel = this._sound.play();
				this._channel.addEventListener(Event.SOUND_COMPLETE, canalCompleto);
				this._btplay.visible = false;
				this._btstop.visible = true;
			}
		}
		
		/**
		 * Clique no botão stop.
		 */
		private function onStop(evt:MouseEvent):void
		{
			this.canalCompleto();
			this._btplay.visible = true;
			this._btstop.visible = false;
		}
		
		/**
		 * Clique no botão microfone.
		 */
		private function onMicrofone(evt:MouseEvent):void
		{
			this.iniciaGravacao();
		}
		
		/**
		 * Gera um novo título para o áudio gravado.
		 * @return	um novo título considerando a hora da gravação
		 */
		private function novoTitulo():String
		{
			var data:Date = new Date();
			return ('gravado em ' + data.date + '-' + (data.month + 1) + '-' + data.fullYear + ' ' + data.hours + '-' + data.minutes + '-' + data.seconds);
		}
		
		/**
		 * Começando a gravar um áudio.
		 */
		private function iniciaGravacao():void
		{
			this.removeChildren();
			this.addChild(this._bg);
			this.addChild(this._msgGravando);
			
			this._mic = Microphone.getMicrophone();
			this._mic.rate = 44;
			this._soundRecording = new ByteArray();
			this._mic.addEventListener(SampleDataEvent.SAMPLE_DATA, getMicData);
		}
		
		/**
		 * Recebendo informações do microfone.
		 */
		private function getMicData(evt:SampleDataEvent):void {
			this._soundRecording.writeBytes(evt.data);
		}
		
		/**
		 * Finalizando uma gravação.
		 */
		private function onFimGravacao(evt:Event = null):void
		{
			// criando o título do áudio
			this._titulo.text = novoTitulo();
			
			// ajustando mensagens
			this.removeChild(this._msgGravando);
			this.addChild(this._msgProcessando);
			
			// recuperando informações gravadas como wave
			this._mic.removeEventListener(SampleDataEvent.SAMPLE_DATA, getMicData);
			var wavWrite:WAVWriter = new WAVWriter();
			wavWrite.numOfChannels = 1;
			wavWrite.sampleBitRate = 16;
			wavWrite.samplingRate = 44100;
			var wav:ByteArray = new ByteArray();
			this._soundRecording.position = 0;
			wavWrite.processSamples(wav, this._soundRecording, 44100, 1);
			wav.position = 0;
			
			// codificando como mp3
			this._mp3Encoder = new ShineMP3Encoder(wav);
			this._mp3Encoder.addEventListener(Event.COMPLETE, onMP3Complete);
			this._mp3Encoder.addEventListener(ProgressEvent.PROGRESS, onMP3Progress);
			this._mp3Encoder.start();
		}
		
		/**
		 * Progresso da codificação mp3.
		 */
		private function onMP3Progress(evt:ProgressEvent):void {
			
		}
		
		/**
		 * MP3 codificado.
		 */
		private function onMP3Complete(evt:Event):void {
			
			// codificador mp3
			this._mp3Encoder.removeEventListener(Event.COMPLETE, onMP3Complete);
			this._mp3Encoder.removeEventListener(ProgressEvent.PROGRESS, onMP3Progress);
			this._mp3Encoder.mp3Data.position = 0;
			
			// arquivo temporário
			this._tempFile = File.createTempDirectory();
			this._tempFile = this._tempFile.resolvePath('gravacao.mp3');
			var stream:FileStream = new FileStream();
			stream.open(this._tempFile, FileMode.WRITE);
			stream.writeBytes(this._mp3Encoder.mp3Data);
			stream.close();
			this._mp3Encoder = null;
			
			// forçando limpeza de memória
			System.gc();
			
			// carregando o som
			if (this._sound != null) {
				if (this._sound.hasEventListener(Event.COMPLETE)) this._sound.removeEventListener(Event.COMPLETE, somCarregado);
				try { this._sound.close(); } catch (e:Error) { }
				this._sound = null;
			}
			this._sound = new Sound();
			this._sound.addEventListener(Event.COMPLETE, somCarregado);
			this._sound.load(new URLRequest(this._tempFile.url));
			
			// ajustando display
			this._btplay.visible = true;
			this._btstop.visible = false;
		}
		
		/**
		 * Um arquivo de som foi carregado.
		 */
		private function somCarregado(evt:Event):void
		{
			// ajustando display
			this.removeChild(this._msgProcessando);
			this.addChild(this._mainControls);
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
			this._btplay.visible = true;
			this._btstop.visible = false;
		}
	}

}