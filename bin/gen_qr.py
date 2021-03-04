#!/usr/local/bin/python3

import sys

import qrcode


def get_qr(token):
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=1,
        border=1)
    qr.add_data(token)
    qr.make(fit=True)
    mx = qr.get_matrix()
    return '\n'.join(''.join([(c and '  ' or 'MM') for c in r]) for r in mx)


if __name__ == '__main__':
    print(get_qr(sys.argv[1]))
