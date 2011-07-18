class Chinchilla < Qt::Widget 
  slots 'sendChat()', 'sendJoinMessage()', 'receiveData()', 'serve()'
  
  attr_accessor :status_label
  
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
