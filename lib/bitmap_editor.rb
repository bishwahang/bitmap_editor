class BitmapEditor
  class InvalidCommand < StandardError; end
  class OutOfBoundCoordinates < StandardError; end

  VALID_COMMANDS = %w[I C L V H S]
  MAX_VALUE_FOR_CO_ORDINATES = 250
  MIN_VALUE_FOR_CO_ORDINATES = 1

  attr_reader :file, :column, :row, :bitmap

  def self.run(file)
    return puts "please provide correct file" if file.nil? || !File.exists?(file)
    self.new(File.open(file, "r")).process
  end

  def initialize(file)
    @file = file
  end

  def process
    file.each_line do |line|
      command, *parameters = line.chomp.split

      raise InvalidCommand.new("The command is invalid") unless VALID_COMMANDS.include? command
      parameters.map! { |e| /\A\d+\z/ === e ? e.to_i : e }

      case command
      when "I"
        initialize_bitmap(*parameters)
      when "C"
        initialize_bitmap(column, row)
      when "L"
        color_pixel(*parameters)
      when "V"
      when "H"
      when "S"
        display_bitmap()
      end
    end
  end

  private

  def initialize_bitmap(column, row)
    @column, @row = column, row

    if @column > MAX_VALUE_FOR_CO_ORDINATES || @row > MAX_VALUE_FOR_CO_ORDINATES
      raise OutOfBoundCoordinates.new("co-ordinate is greater than #{MAX_VALUE_FOR_CO_ORDINATES}")
    end
    if @column < MIN_VALUE_FOR_CO_ORDINATES || @row < MIN_VALUE_FOR_CO_ORDINATES
      raise OutOfBoundCoordinates.new("co-ordinate is smaller than #{MAX_VALUE_FOR_CO_ORDINATES}")
    end

    @bitmap = Array.new(@row+1) { Array.new(@column+1, "O") }
  end

  def color_pixel(column, row, color)
    check_out_of_bound_error(column, row)
    bitmap[row][column] = color
  end

  def display_bitmap
    result = []
    (1..row).each do |row|
      result << bitmap[row][1..column].join
    end
    print result.join("\n")
  end

  def check_out_of_bound_error(y, x)
    if y > column || x > row
      raise OutOfBoundCoordinates.new("co-ordinate is greater than #{MAX_VALUE_FOR_CO_ORDINATES}")
    end

    if y < MIN_VALUE_FOR_CO_ORDINATES || x < MIN_VALUE_FOR_CO_ORDINATES
      raise OutOfBoundCoordinates.new("co-ordinate is smaller than #{MAX_VALUE_FOR_CO_ORDINATES}")
    end
  end
end
