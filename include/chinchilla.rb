class Chinchilla < Qt::Widget 
  slots 'sendChat()', 'sendJoinMessage()', 'receiveData()', 'serve()'
  
  def initialize 
    super
    setWindowTitle "Chinchilla"
    
    initUI
    
    resize 790, 550
    move 200, 200
  end
  
  def server?
    @mode == :server
  end
end
