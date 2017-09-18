class BitmapEditor
  class InvalidCommand < StandardError; end
  class OutOfBoundCoordinates < StandardError; end

  VALID_COMMANDS = %w[I C L V H S]
  MAX_VALUE_FOR_CO_ORDINATES = 250
  MIN_VALUE_FOR_CO_ORDINATES = 1

  attr_reader :file, :column, :row, :bitmap

  def self.run(file)
    return puts "please provide correct file" if file.nil? || !File.exists?(file)
    new(File.open(file, "r")).process
  end

  def initialize(file)
    @file = file
  end

  def process
    file.each_line do |line|
      command, *parameters = line.chomp.split

      raise InvalidCommand.new("The command is invalid") unless VALID_COMMANDS.include? command
      raise InvalidCommand.new("First command should be bitmap initialization") if bitmap.nil? && command != "I"

      parameters.map! { |e| /\A\d+\z/ === e ? e.to_i : e }

      case command
      when "I"
        initialize_bitmap(*parameters)
      when "C"
        initialize_bitmap(column, row)
      when "L"
        color_pixel(*parameters)
      when "V"
        draw_vertical(*parameters)
      when "H"
        draw_horizantal(*parameters)
      when "S"
        display_bitmap()
      end
    end
  end

  private

  def initialize_bitmap(c_col, r_row)
    @column, @row = c_col, r_row

    if column > MAX_VALUE_FOR_CO_ORDINATES || row > MAX_VALUE_FOR_CO_ORDINATES
      raise OutOfBoundCoordinates.new("co-ordinate is greater than #{MAX_VALUE_FOR_CO_ORDINATES}")
    end
    if column < MIN_VALUE_FOR_CO_ORDINATES || row < MIN_VALUE_FOR_CO_ORDINATES
      raise OutOfBoundCoordinates.new("co-ordinate is smaller than #{MIN_VALUE_FOR_CO_ORDINATES}")
    end

    @bitmap = Array.new(row+1) { Array.new(column+1, "O") }
  end

  def color_pixel(c_col, r_row, color)
    check_out_of_bound_error(c_col, r_row)
    bitmap[r_row][c_col] = color
  end

  def draw_vertical(c_col, start_row, end_row, color)
    (start_row..end_row).each do |r|
      color_pixel(c_col, r, color)
    end
  end

  def draw_horizantal(start_col, end_col, r_row, color)
    (start_col..end_col).each do |c|
      color_pixel(c, r_row, color)
    end
  end

  def display_bitmap
    result = []
    (1..row).each do |row|
      result << bitmap[row][1..column].join
    end
    print result.join("\n")
  end

  def check_out_of_bound_error(c_col, r_row)
    if c_col > column || r_row > row
      raise OutOfBoundCoordinates.new("co-ordinate (#{c_col}, #{r_row}) is greater than bitmap boundary: col=#{column}, row=#{row}")
    end

    if c_col < MIN_VALUE_FOR_CO_ORDINATES || r_row < MIN_VALUE_FOR_CO_ORDINATES
      raise OutOfBoundCoordinates.new("co-ordinate (#{c_col}, #{r_row})is smaller than #{MIN_VALUE_FOR_CO_ORDINATES}")
    end
  end
end
