# Read a MP3 file with mpg123 and play it with sdl2

import mpg123
import sdl2, sdl2/audio
import os

if paramCount() != 1:
  echo("Usage: playmp3 <filename>")
  quit(-1)
var Filename = paramStr(1)
    
# Intitialize mpg123   
      
var err = mpg123_init()
if err != MPG123_OK:
  echo("mpg123_init() failed: " & $mpg123_plain_strerror(err))
  quit(-1)

# Create mpg123 instance

var mh = mpg123_new(nil, addr err)
if err != MPG123_OK:
  echo("mpg123_new() failed: " & $mpg123_plain_strerror(err))
  quit(-1)

# Open MP3 file

err = mh.mpg123_open(Filename)
if err != MPG123_OK:
  echo("mpg123_open() failed: " & $mpg123_plain_strerror(err))
  quit(-1)
  
# Get format

var
  rate: clong
  channels: cint
  encoding: cint
err = mh.mpg123_getformat(rate.addr, channels.addr, encoding.addr)
if err != MPG123_OK:
  echo("mpg123_getformat() failed: " & $mpg123_plain_strerror(err))
  quit(-1)
  
echo("Samplerate: " & $rate)
echo("Channels: " & $channels)
echo("Encoding: " & $encoding)
  
# Callback procedure for audio playback

const BufferSizeInBytes = 8192
proc AudioCallback(userdata: pointer; stream: ptr uint8; len: cint) {.cdecl.} = 
  var buffer: array[BufferSizeInBytes, uint8]
  var done: cint
  var err = mh.mpg123_read(addr(buffer[0]), BufferSizeInBytes, addr(done))
  if err == MPG123_NEED_MORE:
    echo("End of file reached")
    quit(0)
  if err != MPG123_OK:
    echo("mpg123_read() failed: " & $mpg123_plain_strerror(err))
    quit(-1)
  if done == 0:
    echo("mpg123_read(): 0 bytes read")
    quit(-1)
  copyMem(stream, addr(buffer[0]), BufferSizeInBytes)

# Init audio playback

if Init(INIT_AUDIO) != SdlSuccess:
  echo("Couldn't initialize SDL")
  quit(-1)
var audioSpec: TAudioSpec
audioSpec.freq = cint(rate)
audioSpec.format = AUDIO_S16 # 16 bit PCM
audioSpec.channels = uint8(channels)
audioSpec.samples = BufferSizeInBytes div 2
audioSpec.padding = 0
audioSpec.callback = AudioCallback
audioSpec.userdata = nil
if OpenAudio(addr(audioSpec), nil) != 0:
  echo("Couldn't open audio device. " & $GetError() & "\n")
  quit(-1)
  
# Start playback and wait in a loop
PauseAudio(0)
echo("Playing...")
while true:
  Delay(100)
