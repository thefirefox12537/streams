#!/usr/bin/python3

# Youtube Live to HLS API Python
# Created by:  @thefirefox12537

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
    m3u8_get = requests.get(f"{url}/index.m3u8").text
    for ts in ['01.m3u8', '02.m3u8']:
        m3u8_get = m3u8_get.replace(ts, f"{url}/{ts}")
    return m3u8_get

def grab(url):
    get = s.get(url, timeout=15).text
    match = re.findall(r'\"hlsManifestUrl\":\"(.*?)\"\}', get)
    decode = unquote(''.join(match))
    if '.m3u8' not in decode:
        return nosignal()
    else:
        m3u8_get = requests.get(decode).text
        for code in ['403 ', '404 ', '500 ']:
            if code in m3u8_get:
                return nosignal()
            else:
                break
        return m3u8_get

s = requests.Session()
result = grab(str(sys.argv[1]))
print(result)
