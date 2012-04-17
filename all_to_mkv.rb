# Converts all videos in current directory to mkvs, and puts them in a time stamped folder.

# doesn't handle spaces in file names!

threads=4


ffmpeg=`which ffmpeg`

if (ffmpeg.length<1)
  puts "Can't find ffmpeg. You may need to install it."
  exit
else
  puts ":: Found ffmpeg ::"
end



files=Dir.entries(".")
videos=[]

# check file type
files.each do |file|
  mime_type=`file --mime-type #{file}`.split('/')[0].split(': ')[1]
  if mime_type=='video'
    videos << file
  end
end

puts "Found #{videos.length} videos: "
videos.each do |video|
  puts video
end

folder_name='videos_'+Time.now.to_i.to_s
Dir.mkdir(File.join(Dir.pwd, folder_name), 0700)

videos.each do |input|
  output=(folder_name+"/")+(File.basename(input, ".*"))
  ffmpeg_command="ffmpeg -threads #{threads} -i #{input} -threads #{threads} -r 30 -vf 'scale=1280:-1' -vcodec libx264 -acodec libmp3lame -sameq #{output}.mkv"
  puts ffmpeg_command
  `#{ffmpeg_command}`
  # indicate errors
  # log errors
end

