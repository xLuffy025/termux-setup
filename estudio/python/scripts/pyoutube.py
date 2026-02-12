from pytube import YouTube

url = input("Enter YouTube video URL: ")
yt = YouTube(url)

stream = yt.streams.filter(progressive=True,
                           file_extension="mp4") \
                   .order-by("resolution").desc().first()


