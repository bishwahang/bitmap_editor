# Bitmap editor
Pixel co-ordinates are a pair of integers: a column number between 1 and 250, and a row number between 1 and 250.
Bitmaps starts at coordinates 1,1. Colours are specified by capital letters.

There are 6 supported commands:
  * I M N - Create a new M x N image with all pixels coloured white (O).
  * C - Clears the table, setting all pixels to white (O).
  * L X Y C - Colours the pixel (X,Y) with colour C.
  * V X Y1 Y2 C - Draw a vertical segment of colour C in column X between rows Y1 and Y2 (inclusive).
  * H X1 X2 Y C - Draw a horizontal segment of colour C in row Y between columns X1 and X2 (inclusive).
  * S - Show the contents of the current image

# Exceptions

  Any command that is out of the above rule will throw an exception.


# Running

`bin/bitmap_editor examples/show.txt`

# Specs

`bundle exec rspec spec/`
