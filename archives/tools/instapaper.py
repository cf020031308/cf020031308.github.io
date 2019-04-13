#qpy:qpyapp

import requests
import androidhelper


URL = 'https://www.instapaper.com/api/add'
AUTH = ('username', '***')


ad = androidhelper.Android()
url = ad.getClipboard().result.strip()
ret = ''
ad.makeToast('Saving: ' + url)
try:
    assert url, 'no URL'
    resp = requests.get(URL, auth=AUTH, params={'url': url})
    ret = '<%s>: %s' % (
        resp.status_code,
        resp.headers.get('X-Instapaper-Title') or resp.content)
    if not resp.status_code < 300:
        raise Exception(ret)
    ad.makeToast(ret)
except Exception as e:
    ad.vibrate(100)
    ad.notify('failed to save to instapaper', ret or str(e))
