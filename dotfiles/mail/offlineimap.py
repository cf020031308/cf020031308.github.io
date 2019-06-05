import os


g_remote2local = {
    '&V4NXPpCuTvY-': 'spams',
    '&XfJSIJZk-': 'deleted',
    '&XfJT0ZAB-': 'sent',
    '&Xn9USpCuTvY-': 'ads',
    '&i6KWBZCuTvY-': 'subs',
    '&kc2JgQ-': 'important',
    '&g0l6P3ux-': 'drafts',
    '&Y6hef5CuTvY-': 'push',
}

g_local2remote = {v: k for k, v in g_remote2local.items()}

g_ignored = {'deleted'}


def get_passwd(name):
    with open('%s/.accounts/%s' % (os.environ['HOME'], name)) as file:
        return file.read().strip()


def local2remote(folder):
    return g_local2remote.get(folder, folder)


def remote2local(folder):
    return g_remote2local.get(folder, folder)


def mbfilter(_, folder):
    return folder not in g_ignored
