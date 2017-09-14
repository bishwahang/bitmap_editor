class BitmapEditor
  class InvalidCommand < StandardError; end
  class OutOfBoundCoordinates < StandardError; end

  VALID_COMMANDS = %w[I C L V H S]
  MAX_VALUE_FOR_CO_ORDINATES = 250
  MIN_VALUE_FOR_CO_ORDINATES = 1

  attr_reader :file, :m, :n, :bit_map

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

      case command
      when "I"
        initialize_bitmap(*parameters)
      when "C"
      when "L"
      when "V"
      when "H"
      when "S"
        display_bitmap()
      end
    end
  end

  private

  def initialize_bitmap(m, n)
    @m, @n = m.to_i, n.to_i

    if @m > MAX_VALUE_FOR_CO_ORDINATES || @n > MAX_VALUE_FOR_CO_ORDINATES
      raise OutOfBoundCoordinates.new("co-ordinate is greater than #{MAX_VALUE_FOR_CO_ORDINATES}")
    end

    if @m < MIN_VALUE_FOR_CO_ORDINATES || @n < MIN_VALUE_FOR_CO_ORDINATES
      raise OutOfBoundCoordinates.new("co-ordinate is smaller than #{MAX_VALUE_FOR_CO_ORDINATES}")
    end

    @bitmap = Array.new(@n+1) { Array.new(@m+1, "O") }
  end

  def display_bitmap
    result = []
    (1..n).each do |row|
      result << @bitmap[row][1..m].join
    end
    print result.join("\n")
  end
end
