require 'Qt'
require 'net/telnet'

load 'include/drawingarea.rb'
load 'include/chinchilla.rb'
load 'include/chinchilla_ui.rb'
load 'include/chinchilla_functions.rb'
load 'include/chinchilla_server.rb'
load 'include/menu.rb'
load 'include/user.rb'

app = Qt::Application.new ARGV
Menu.new
app.exec
