class DrawingArea < Qt::Widget 
  attr_accessor :drawing, :image, :myPenWidth, :myPenColor
  
  slots 'myPenWidthChange(int)', 'clear()'
  
  COLORS =  [
              {name: "black", code: "#000000"},
              {name: "red", code: "#FF0000"},
              {name: "green", code: "#00FF00"},
              {name: "blue", code: "#0000FF"},
              {name: "cyan", code: "#00FFFF"},
              {name: "magenta", code: "#FF00FF"},
              {name: "yellow", code: "#FFFF00"},
              {name: "violet", code: "#5D005D"},
            ]
  
  def initialize(parent, rectangle) 
    super(parent)
    self.geometry = rectangle
    
    @drawing = false
    @image = Qt::Image.new(width,height,Qt::Image::Format_RGB16)
    @image.fill qRgb(255, 255, 255)
    @myPenWidth = 0
    @myPenColor = 0
    @lastPoint = Qt::Point.new 0, 0
    
    @parent = parent
  end
  
  def mousePressEvent(event)
    super
    if event.button == Qt::LeftButton
      @drawing = true
      @lastPoint = event.pos
    end
  end
  
  def mouseMoveEvent(event)
    super
    if event.buttons && Qt::LeftButton && @drawing
      iDrawLineTo event.pos
    end
  end
  
  def mouseReleaseEvent(event)
    super
    if event.buttons && Qt::LeftButton && @drawing
      iDrawLineTo event.pos
      @drawing = false
    end
  end
  
  def paintEvent event
    painter = Qt::Painter.new self
    dirtyRect = event.rect
    painter.drawImage dirtyRect, @image, dirtyRect
    painter.end
  end
  
  def iDrawLineTo endPoint
    drawLineFromTo @lastPoint.x, @lastPoint.y, endPoint.x, endPoint.y, @myPenColor.to_s, @myPenWidth.to_s
    $chinchilla.sendData "l|#{@lastPoint.x}|#{@lastPoint.y}|#{endPoint.x}|#{endPoint.y}|#{@myPenColor.to_s}|#{@myPenWidth.to_s}"
    @lastPoint = endPoint
  end
  
  def drawLineFromTo(beginPoint_x, beginPoint_y, endPoint_x, endPoint_y, penColor, penWidth)
    puts "Drawing line from (#{beginPoint_x}/#{beginPoint_y}) to (#{endPoint_x}/#{endPoint_y}) with #{penColor} color and width #{penWidth}"
    beginPoint = Qt::Point.new beginPoint_x.to_i, beginPoint_y.to_i
    endPoint = Qt::Point.new endPoint_x.to_i, endPoint_y.to_i
    
    painter = Qt::Painter.new @image
    painter.setPen(Qt::Pen.new(Qt::Brush.new(Qt::Color.new(COLORS[penColor.to_i][:code])), penWidth.to_i, Qt::SolidLine, Qt::RoundCap, Qt::RoundJoin))
    painter.drawLine beginPoint, endPoint 
    
    rad = @myPenWidth / 2 + 2;
    
    update Qt::Rect.new(@lastPoint, endPoint).normalized.adjusted(-rad, -rad, +rad, +rad)
    painter.end
  end
  
  def myPenWidthChange new_width
    @myPenWidth = new_width
  end
  
  def clearing
    @image.fill qRgb(255, 255, 255)
    update
  end
  
  def clear
    $chinchilla.sendData "f|c"
    clearing
  end
  
  COLORS.each_with_index do |color, index|
    eval %Q{
      slots :myPenColorChangeTo#{color[:name].to_s.capitalize}
      def myPenColorChangeTo#{color[:name].to_s.capitalize}
        @myPenColor = #{index.to_s}
      end
    }
  end
end
