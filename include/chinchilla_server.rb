class ChinchillaServer < Qt::Widget 
  attr_reader :server
  slots "serve()", "receiveData()"
  
  def initialize
    super
    @logFile = File.new("#{Dir.home}/.config/chinchilla/logs/#{Time.now.strftime "%Y-%m-%d_%H:%M:%S"}.log", "w")
  end
  
  def set(port)
    @port = port
    initVars
    initTcpServer
  end
  
  def initTcpServer
    @server = Qt::TcpServer.new self
    @server.listen(Qt::HostAddress.new(Qt::HostAddress::Any), @port)
    Qt::Object.connect(@server, SIGNAL('newConnection()'), self, SLOT('serve()'))
    
    if @server.isListening
      $chinchilla.status_label.text = "Server working on:\nIP: #{}\nPort: #{@server.serverPort}"
    else
      $chinchilla.status_label.text = "Server doesn't work."
    end
  end
  
  def initVars
    @users = []
    
    @users[0] = User.new(0)
    @users[0].nick = "System"
    
    @currentClientId = 0
    @chat = []
  end
  
  def serve
    @currentClientId += 1
    clientId = @currentClientId
    
    @users[clientId] = User.new clientId
    @users[clientId].socket = @server.nextPendingConnection
    @users[clientId].socket.connect(SIGNAL :readyRead) {
      receiveData(clientId)
    }
    @users[clientId].socket.connect(SIGNAL :disconnected) {
      addToChat 0, "User [#{@users[clientId].nick}] left Chinchilla."
    }
  end
  
  def sendData clientId, data
    @users[clientId].socket.write data
  end
  
  def sendDataToAll data
    @users[1..@users.count-1].each do |user|
      sendData user.clientId, data
    end
  end
  
  def sendDataToAlmostAll clientId, data
    usr = Array.new << @users[clientId]
    (@users[1..@users.count-1]-usr).each do |user|
      sendData user.clientId, data
    end
  end
  
  def receiveData(clientId)
    line = @users[clientId].socket.readLine.to_s
    #puts line
    
    if line =~ /^j\|.+$/
      @users[clientId].nick = line.scan(/^j\|(.+)$/).first.first
      addToChat 0, "User [#{@users[clientId].nick}] joined Chinchilla."
    elsif line =~ /^c\|.+$/
      addToChat clientId, line.scan(/^c\|(.+)$/).first.first
    elsif line =~ /^l\|.+\|.+\|.+\|.+\|.+\|.+$/
      sendDataToAlmostAll clientId, line
    elsif line =~ /^f\|c$/
      sendDataToAlmostAll clientId, line
    end
  end
  
  def addToChat(clientId, msg)
    @chat << {user: clientId, text: msg}
    update_chat
    @logFile.puts "<#{@users[clientId].nick}>: #{msg}"
    @logFile.flush
  end
  
  def update_chat
    chat = @chat.last
    sendDataToAll "c|#{@users[chat[:user]].nick}|#{chat[:text]}"
  end
end
