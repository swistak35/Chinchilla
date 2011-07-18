class User
  attr_accessor :nick, :clientId, :socket
  
  def initialize clientId
    @clientId = clientId
  end
end
