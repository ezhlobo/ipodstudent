require 'RMagick'
include Magick

$options = {
  font_size: 23,
  line_height: 24,
  font: 'fonts/ptmono.ttf',
  text_background: 'white',
  background: 'black'
}

source_file = ARGV[0]
unless source_file or !File.exists?(source_file)
  puts '[error] Unknown file'
end

output_dir = ARGV[1]
unless output_dir
  output_dir = 'result'
  puts "output directory: #{output_dir}"
end
unless File.exists?(output_dir)
  Dir.mkdir(output_dir)
end

def save_image(text_lines, dir, id)
  img = ImageList.new
  gs = Magick::Draw.new
  gs.pointsize = $options[:font_size]
  gs.font = $options[:font]
  gs.undercolor = $options[:text_background]

  text_height = text_lines.length * $options[:line_height]
  height = text_height > 480 ? 960 : 480

  img.new_image(480, height) {
    self.background_color = $options[:background]
  }

  position = -4
  text_lines.each do |row|
    position += $options[:line_height]
    if row.size > 0
      gs.annotate(img, 0, 0, 0, position, row)
    end
  end

  img.write("#{dir}/#{id}.gif")
end

def save_item(dir, text)
  def word_wrap(text, columns = 34)
    text.split("\n").collect do |line|
      line.length > columns ? line.gsub(/(.{1,#{columns}})(\s+|$)/, "\\1\n").strip : line
    end * "\n"
  end

  text = word_wrap(text)
  text_lines = text.split("\n")
  max_rows = 960 / $options[:line_height]
  max_images = (text_lines.length.to_f / max_rows).ceil

  index = 1
  while index <= max_images do
    save_image(text_lines.shift(max_rows), dir, index)
    index += 1
  end
end

File.open(source_file).read.split("\n////\n").each_with_index do |item, index|
  title = item.split("\n")[0]
  text = item.gsub(/^#{title}\n/, '')

  dir = title or index
  dir = "#{output_dir}/#{dir}"
  while File.exists?(dir) do
    dir = "#{dir}_"
  end

  Dir.mkdir(dir)

  save_item(dir, text)
end

exit
