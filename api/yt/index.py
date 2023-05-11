#! /usr/bin/python3

from urllib.parse import unquote
import requests
import re
import os
import sys

windows = False
if 'win' in sys.platform:
    windows = True

def nosignal():
    url = 'http://thefirefox12537.github.io/streams/nosignal'
    m3u8_get = requests.get(url + '/index.m3u8').text
    repl_1 = m3u8_get.replace('01.m3u8', url + '/01.m3u8')
    repl_2 = repl_1.replace('02.m3u8', url + '/02.m3u8')
    return repl_2

def grab(url):
    get_m3u8 = s.get(url, timeout=15).text
    match_m3u8 = re.findall(r'\"hlsManifestUrl\":\"(.*?)\"\}', get_m3u8)
    decode_m3u8 = unquote(''.join(match_m3u8))
    if '.m3u8' not in decode_m3u8:
        return nosignal()
    else:
        return requests.get(decode_m3u8).text

s = requests.Session()
result = grab(str(sys.argv[1]))
print(result)
