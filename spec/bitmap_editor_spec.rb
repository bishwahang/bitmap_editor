require "spec_helper"

RSpec.describe BitmapEditor do
  it "returns correct message when file is not given or is not present" do
    expect { described_class.run("foobar") }.to output("please provide correct file\n").to_stdout
  end

  it "raises InvalidCommand if first command is not Initialization" do
    stub_file_with("S\n")
    expect { described_class.run("filename") }.to raise_error BitmapEditor::InvalidCommand
  end

  it "raises OutOfBoundCoordinates Error if column or row is greater than 250" do
    stub_file_with("I 251 1\n")
    expect { described_class.run("filename") }.to raise_error BitmapEditor::OutOfBoundCoordinates

    stub_file_with("I 1 251\n")
    expect { described_class.run("filename") }.to raise_error BitmapEditor::OutOfBoundCoordinates
  end

  it "raises OutOfBoundCoordinates Error if column or row is less than 1" do
    stub_file_with("I 0 1\n")
    expect { described_class.run("filename") }.to raise_error BitmapEditor::OutOfBoundCoordinates

    stub_file_with("I 1 0\n")
    expect { described_class.run("filename") }.to raise_error BitmapEditor::OutOfBoundCoordinates
  end

  it "raises InvalidCommand error if invalid command is in the input file" do
    stub_file_with("X\n")
    expect { described_class.run("filename") }.to raise_error BitmapEditor::InvalidCommand
  end

  it "initializes bitmap with correct row and column and fills with default 0" do
    stub_file_with("I 5 3\nS")
    expect do
      described_class.run("filename")
    end.to output("OOOOO\nOOOOO\nOOOOO").to_stdout
  end

  it "raises OutOfBoundCoordinates Error if if co-ordinates are less than 1" do
    stub_file_with("I 3 3\nL 0 3 R")
    expect { described_class.run("filename") }.to raise_error BitmapEditor::OutOfBoundCoordinates

    stub_file_with("I 3 3\nL 3 0 R")
    expect { described_class.run("filename") }.to raise_error BitmapEditor::OutOfBoundCoordinates
  end

  it "raises OutOfBoundCoordinates Error if if co-ordinates are greater than initialized bitmap values" do
    stub_file_with("I 3 3\nL 1 4 R")
    expect { described_class.run("filename") }.to raise_error BitmapEditor::OutOfBoundCoordinates

    stub_file_with("I 3 3\nL 4 1 R")
    expect { described_class.run("filename") }.to raise_error BitmapEditor::OutOfBoundCoordinates
  end

  it "colors the pixel with correct color" do
    stub_file_with("I 1 1\nL 1 1 R\nS")
    expect do
      described_class.run("filename")
    end.to output("R").to_stdout
  end

  it "resets the bitmap with 0" do
    stub_file_with("I 1 1\nL 1 1 R\nC\nS")
    expect do
      described_class.run("filename")
    end.to output("O").to_stdout
  end

  it "draws vertical" do
    # input file:
    # I 2 3
    # V 2 1 3 R
    # S
    #
    # output:
    # OR
    # OR
    # OR

    stub_file_with("I 2 3\nV 2 1 3 R\nS")
    expect do
      described_class.run("filename")
    end.to output("OR\nOR\nOR").to_stdout
  end

  it "draws horizantal" do
    # input file:
    # I 3 2
    # H 1 3 2 R
    # S
    #
    # output:
    # OOO
    # RRR

    stub_file_with("I 3 2\nH 1 3 2 R\nS")
    expect do
      described_class.run("filename")
    end.to output("OOO\nRRR").to_stdout
  end

  it "executes stream of command correctly" do
    # input file
    # I 5 6
    # L 1 3 A
    # V 2 3 6 W
    # H 3 5 2 Z
    # S
    #
    # output:
    # OOOOO
    # OOZZZ
    # AWOOO
    # OWOOO
    # OWOOO
    # OWOOO

    stub_file_with("I 5 6\nL 1 3 A\nV 2 3 6 W\nH 3 5 2 Z\nS")
    expect do
      described_class.run("filename")
    end.to output(
      "OOOOO\nOOZZZ\nAWOOO\nOWOOO\nOWOOO\nOWOOO"
    ).to_stdout
  end

  def stub_file_with(content)
    expect(File).to receive(:exists?).and_return(true)
    expect(File).to receive(:open).and_return(content)
  end
end
