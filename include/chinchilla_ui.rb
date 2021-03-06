class Chinchilla
  def set(mode, nick, host, port)
    @mode, @nick, @host, @port = mode, nick, host, port
    
    @nick_label.text = @nick
    
    if server?
      @server = ChinchillaServer.new
      @server.set @port
    end
    
    @socket = Qt::TcpSocket.new self
    @socket.connectToHost(@host, @port)
    
    Qt::Object.connect(@socket, SIGNAL('connected()'), self, SLOT('sendJoinMessage()'))
    Qt::Object.connect(@socket, SIGNAL('readyRead()'), self, SLOT('receiveData()'))
  end
  
  def initUI
    @drawing_area = DrawingArea.new self, Qt::Rect.new(5, 5, 570, 370)
    
    #i = 0
    #DrawingArea::COLORS.each do |name, value|
      #eval %Q{
        #@button_#{name.to_s} = Qt::PushButton.new self
        #@button_#{name.to_s}.geometry = Qt::Rect.new(#{580 + 105 * (i%2)}, #{155 + (i/2)*25}, 100, 20)
        #@button_#{name.to_s}.text = "#{name.to_s.capitalize}"
        #Qt::Object.connect(@button_#{name.to_s}, SIGNAL('clicked()'),
                           #@drawing_area, SLOT('myPenColorChangeTo#{name.to_s.capitalize}()'))
      #}
      #i += 1
    #end
    
    colors = DrawingArea::COLORS
    for i in 0..(colors.count-1) do
      eval %Q{
        @button_#{colors[i][:name].to_s} = Qt::PushButton.new self
        @button_#{colors[i][:name].to_s}.geometry = Qt::Rect.new(#{580 + 105 * (i%2)}, #{155 + (i/2)*25}, 100, 20)
        @button_#{colors[i][:name].to_s}.text = "#{colors[i][:name].to_s.capitalize}"
        Qt::Object.connect(@button_#{colors[i][:name].to_s}, SIGNAL('clicked()'),
                           @drawing_area, SLOT('myPenColorChangeTo#{colors[i][:name].to_s.capitalize}()'))
      }
    end
    
    
    @brush_spinbox = Qt::SpinBox.new self
    @brush_spinbox.geometry = Qt::Rect.new 580, 105, 100, 45
    @brush_spinbox.minimum = 1
    @brush_spinbox.maximum = 20
    @brush_spinbox.prefix = "Brush"+":  "
    Qt::Object.connect(@brush_spinbox, SIGNAL('valueChanged(int)'), @drawing_area, SLOT('myPenWidthChange(int)'))
    @brush_spinbox.value = 2
    
    @button_clear = Qt::PushButton.new self
    @button_clear.geometry = Qt::Rect.new 685, 105, 100, 45
    @button_clear.text = "clear".upcase
    Qt::Object.connect(@button_clear, SIGNAL('clicked()'), @drawing_area, SLOT('clear()'))
    
    @status_label = Qt::Label.new self
    @status_label.geometry = Qt::Rect.new 580, 5, 205, 45
    
    @chat_browser = Qt::TextBrowser.new self
    @chat_browser.geometry = Qt::Rect.new 5, 380, 570, 130
    @chat_browser.setOverwriteMode false
    def @chat_browser.addText(text)
      setPlainText text+"\n"+plainText
    end
    
    @nick_label = Qt::Label.new self
    @nick_label.geometry = Qt::Rect.new 5, 515, 100, 30
    
    @chat_entry = Qt::LineEdit.new self
    @chat_entry.geometry = Qt::Rect.new 110, 515, 360, 30
    
    @chat_button = Qt::PushButton.new self
    @chat_button.geometry = Qt::Rect.new 470, 515, 100, 30
    @chat_button.text = "Send"
    Qt::Object.connect(@chat_button, SIGNAL('clicked()'), self, SLOT('sendChat()'))
    
    @action_send = Qt::Action.new self
    @action_send.setShortcut("Return");
    Qt::Object.connect(@action_send, SIGNAL('triggered()'), @chat_button, SLOT('click()'))
    self.addAction @action_send
  end
end
