class Chinchilla
  def sendChat
    puts "dupa"
    unless @chat_entry.text.empty?
      sendData "c|#{@chat_entry.text}"
      @chat_entry.text = ""
    end
  end
  
  def sendJoinMessage
    unless server?
      @status_label.text = "Connected to:\nHost: #{@host}\nPort: #{@port}"
    end
    sendData "j|#{@nick}"
  end
  
  def sendData(data)
    @socket.write data
  end
  
  def receiveData
    line = @socket.readLine.to_s
    #puts line
    
    if line =~ /^c\|.+\|.+$/
      chat = line.scan(/^c\|(.+)\|(.+)$/).first
      @chat_browser.addText "<#{chat[0]}>: #{chat[1]}"
    elsif line =~ /^l\|.+\|.+\|.+\|.+\|.+\|.+$/
      line.scan(/(l\|[0-9]{1,3}\|[0-9]{1,3}\|[0-9]{1,3}\|[0-9]{1,3}\|[0-9]{1,2}\|[0-9]{1,2})/).each do |slice|
        tab = slice.first.split("|")
        @drawing_area.drawLineFromTo tab[1], tab[2], tab[3], tab[4], tab[5], tab[6]
      end
    elsif line =~ /^f\|c$/
      @drawing_area.clearing
    end
  end
end
