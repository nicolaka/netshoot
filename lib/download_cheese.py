#!/usr/bin/python

import youtube_dl

def download_eric_prydz_videos():
    search_query = "Eric Prydz"

    youtube_search_url = f"https://www.youtube.com/results?search_query={search_query}"

    ydl_opts = {
        'format': 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best',
        'outtmpl': '%(title)s.%(ext)s',
    }
    ydl = youtube_dl.YoutubeDL(ydl_opts)

    with ydl:
        result = ydl.extract_info(youtube_search_url, download=False)

    if 'entries' in result:
        videos = result['entries']
        for video in videos:
            video_url = f"https://www.youtube.com/watch?v={video['id']}"
            try:
                ydl.download([video_url])
                print(f"Downloaded: {video['title']}")
            except Exception as e:
                print(f"Error downloading video: {video_url}\n{str(e)}")

if __name__ == "__main__":
    download_eric_prydz_videos()
    print("CIREZ DDDDDDDDDDDD")