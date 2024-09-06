from gtts import gTTS

tts = gTTS("The system is ready to detect currency.")
tts.save("static/audio/ready.mp3")
