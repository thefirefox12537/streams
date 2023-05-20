#!/bin/bash
python index.py ../guide.xml general.txt "12537.stream.ip.tv Playlist" https://12537-stream-ip-tv.xyz
cd ..
tar -czvf guide.xml.gz guide.xml
rm guide.xml
exit