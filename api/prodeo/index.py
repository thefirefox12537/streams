#!/usr/bin/python3

import requests
import os
import sys

windows = False
if 'win' in sys.platform:
    windows = True

def nosignal():
    url = 'http://thefirefox12537.github.io/streams/nosignal'
    get = requests.get(url + '/index.m3u8').text
    result = get.replace('01.m3u8', url + '/01.m3u8')
    result = result.replace('02.m3u8', url + '/02.m3u8')
    return result

def grab(url):
    response = s.get(url, timeout=15).text
    if '.m3u8' not in response:
        response = nosignal()
    return response

s = requests.Session()
result = grab('https://vidiohls.thescript2.workers.dev/apiv2.php?id=' + str(sys.argv[1]))
print(result)
