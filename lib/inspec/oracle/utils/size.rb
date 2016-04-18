class Size
  include Comparable

  def initialize(size)
    @size = size
    case
    when size =~ /(\d+)K/i
      @size_number = $~[1].to_i * 1024
    when size =~ /(\d+)M/i
      @size_number = $~[1].to_i * 1024 * 1024
    when size =~ /(\d+)G/i
      @size_number = $~[1].to_i * 1024 * 1024 * 2014
    when size =~ /(\d+)T/i
      @size_number = $~[1].to_i * 1024 * 1024 * 2014 * 1024
    else
      @size_number = size.to_i
    end
  end

  def <=>(raw_size)
    size = Size.new(raw_size) unless raw_size.is_a?(Size)
    @size_number <=> size.number
  end

  protected

  def number
    @size_number
  end

end