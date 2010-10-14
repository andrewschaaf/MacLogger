

def isEncodedVarint(data):
    return data and (ord(data[-1]) < 128) and all((ord(c) >= 128) for c in data[:-1])

def svarintLength(x):
    return len(svarintEncode(x))


def uvarintLength(x):
    return len(uvarintEncode(x))


def svarintEncode(s):
    return uvarintEncode(_s2u(s))


def svarintDecode(data):
    return svarint_pos_decode(data, 0)[0]

def svarintRead(f):
    return _u2s(uvarintRead(f))


def _u2s(u):
    if u % 2 == 1:
        return -((u + 1) / 2)
    else:
        return u / 2


def _s2u(s):
    return 2 * abs(s) - (1 if s < 0 else 0)


def svarint_pos_decode(data, pos):
    u, pos = uvarint_pos_decode(data, pos)
    return _u2s(u), pos


def svarintsDecode(data):
    pos = 0
    while pos < len(data):
        x, pos = svarint_pos_decode(data, pos)
        yield x


def uvarintsDecode(data):
    pos = 0
    while pos < len(data):
        x, pos = uvarint_pos_decode(data, pos)
        yield x


def uvarintWrite(f, x):
    f.write(uvarintEncode(x))


def uvarintRead(f):
    bs = []
    while True:
        b = f.read(1)
        if not b:
            raise EOFError
        bs.append(b)
        if not (ord(b) & 128):
            return uvarintDecode(''.join(bs))


def uvarintEncode(x):
    bs = []
    while True:
        b = (x % 128) | (128 if x >= 128 else 0)
        bs.append(chr(b))
        
        if not (b & 128):
            return ''.join(bs)
        
        x = int(x / 128)


def uvarintDecode(x):
    return uvarint_pos_decode(x, 0)[0]


def uvarint_pos_decode(s, pos):
    result = 0
    shift = 0
    while True:
        
        b = ord(s[pos])
        pos += 1
        
        result |= ((b & 0x7f) << shift)
        shift += 7
        if not (b & 0x80):
            return (result, pos)


def test():
    
    print('Testing...')
    
    for i in range(10000):
        assert i == uvarintDecode(uvarintEncode(i)), i
    
    for i in range(-10000, 10000):
        assert i == svarintDecode(svarintEncode(i)), repr([i, uvarintDecode(svarintEncode(i)), svarintDecode(svarintEncode(i))])
    
    print('Done')


if __name__ == '__main__':
    test()
