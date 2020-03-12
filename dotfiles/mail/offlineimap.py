import os


g_remote2local = {
    '&V4NXPpCuTvY-': 'spams',
    '&XfJSIJZk-': 'deleted',
    '&XfJT0ZAB-': 'sent',
    '&Xn9USpCuTvY-': 'ads',
    '&i6KWBZCuTvY-': 'subs2',
    '&kc2JgQ-': 'important',
    '&g0l6P3ux-': 'drafts',
    '&Y6hef5CuTvY-': 'push',
}

g_local2remote = {v: k for k, v in g_remote2local.items()}

g_ignored = {'deleted'}


def get_account(name):
    with open('%s/.accounts/mail' % os.environ['HOME']) as file:
        lines = (line for line in file.read().strip().splitlines() if line)
    for user, passwd in zip(lines, lines):
        if name in user:
            return user, passwd


def local2remote(folder):
    return g_local2remote.get(folder, folder)


def remote2local(folder):
    return g_remote2local.get(folder, folder)


def mbfilter(_, folder):
    return folder not in g_ignored
