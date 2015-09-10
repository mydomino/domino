class Image

  def initialize size
    @image_data = []
    size.times do |column|
      @image_data.push([])
      size.times do |row|
        @image_data[column][row] = 0
      end
    end
  end


  def image_data
    result = ''
    @image_data.each do |row|
      column.each do |point|
        result << point
      end
    end
  end


end