UNIT = {
    '1': 'one',
    '2': 'two',
    '3': 'three',
    '4': 'four',
    '5': 'five',
    '6': 'six',
    '7': 'seven',
    '8': 'eight',
    '9': 'nine',
    '10': 'ten',
    '11': 'eleven',
    '12': 'twelve',
    '13': 'thirteen',
    '14': 'fourteen',
    '15': 'fifteen',
    '16': 'sixteen',
    '17': 'seventeen',
    '18': 'eighteen',
    '19': 'nineteen'
}

TENS = {
    '2': 'twenty',
    '3': 'thirty',
    '4': 'forty',
    '5': 'fifty',
    '6': 'sixty',
    '7': 'seventy',
    '8': 'eighty',
    '9': 'ninety'
}


def translate(n):
    w = ''
    n = str(n)
    if len(n) == 3:
        w += UNIT[n[0]] + ' hundred'
        n = n[1:]
        if n == '00':
            return w
        w += ' and '
    if n in UNIT:
        w += UNIT[n]
        return w
    if n[0] != '0':
        w += TENS[n[0]]
        if n[1] == '0':
            return w
    w += '-' + UNIT[n[1]]
    return w


def count(n):
    return len(translate(n).replace(' ', '').replace('-', ''))


assert count(342) == 23 and count(115) == 20
print sum(count(i) for i in range(1, 1000)) + len('onethousand')
