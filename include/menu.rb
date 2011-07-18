class Menu < Qt::Widget 
  slots 'client()', 'server()'
  
  def initialize
    super
    setWindowTitle "Chinchilla"
    
    initUI
    resize 400,200
    move 200, 200
    show
  end

  def initUI
    @nickname = Qt::LineEdit.new self
    @nickname.text = "Guest"+rand(1000).to_s
    @nickname.geometry = Qt::Rect.new(120, 20, 241, 31)
    
    @host = Qt::LineEdit.new self
    @host.text = "localhost"
    @host.geometry = Qt::Rect.new(120, 70, 151, 31)
    
    @port = Qt::LineEdit.new self
    @port.text = "1234"
    @port.geometry = Qt::Rect.new(280, 70, 81, 31)
    
    @server = Qt::PushButton.new self
    @server.text = "Server"
    @server.geometry = Qt::Rect.new(30, 120, 151, 51)
    Qt::Object.connect(@server, SIGNAL('clicked()'), self, SLOT('server()'))
    
    @client = Qt::PushButton.new self
    @client.text = "Client"
    @client.geometry = Qt::Rect.new(210, 120, 151, 51)
    Qt::Object.connect(@client, SIGNAL('clicked()'), self, SLOT('client()'))
    
    @nickname_label = Qt::Label.new self
    @nickname_label.text = "Nickname"
    @nickname_label.geometry = Qt::Rect.new(30, 20, 71, 31)
    
    @hostport_label = Qt::Label.new self
    @hostport_label.text = "Host/port"
    @hostport_label.geometry = Qt::Rect.new(30, 70, 71, 31)
  end
  
  def client
    run_chinchilla :client
  end
  
  def server
    run_chinchilla :server
  end
  
  def run_chinchilla mode
    self.close
    $chinchilla = Chinchilla.new
    $chinchilla.set mode, @nickname.text, @host.text, @port.text.to_i
    $chinchilla.show
  end
end

