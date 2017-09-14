require "spec_helper"

RSpec.describe BitmapEditor do
  it "returns correct message when file is not given or is not present" do
    expect { described_class.run("foobar") }.to output("please provide correct file\n").to_stdout
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

  def stub_file_with(content)
    expect(File).to receive(:exists?).and_return(true)
    expect(File).to receive(:open).and_return(content)
  end
end
