#/bin/python
import sys
import re
import subprocess

def extract_youtube_video_id(url):
        m = re.search("www.youtube.com/watch\?v=(\S+)", url)
        if m is None:
                return None
        return m.group(1)

def get_file_with_id (video_id):
        p = subprocess.Popen("ls", stdout=subprocess.PIPE, shell=True)
        (output, err) = p.communicate()
        if err is not None:
                return None

        files = output.split('\n')
        for f in files:
                #print f
                if f.find(video_id) != -1:
                        return f

        return None

def main():
        with open (sys.argv[1]) as f:
                for video_url in f:
                        #print video_url
                        video_id = extract_youtube_video_id (video_url)
                        #print video_id
                        if video_id is None:
                                continue

                        fname = get_file_with_id (video_id)
                        if fname is None:
                                continue

                        print fname

if __name__ == "__main__":
        main()
