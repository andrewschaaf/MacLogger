
import subprocess, os, sys

from varints import uvarintRead, uvarintsDecode


def main():
    
    signalName = sys.argv[1]
    
    signal_repr = {
        'mouse-pos': mouse_pos,
        'input-idle': input_idle,
        'front-window': front_window,
    }[signalName]
    
    
    signalDir = os.path.expanduser('~/Library/Application Support/MacLogger/signals/%s' % signalName)
    path = '%s/%s' % (signalDir, list(sorted(os.listdir(signalDir)))[-1])
    #p = subprocess.Popen(['tail', '-n', '0', '-f', path], stdout=subprocess.PIPE)
    #f = p.stdout
    try:
        with open(path, 'rb') as f:
            print path
            while True:
                msDelta = uvarintRead(f)
                dataLength = uvarintRead(f)
                data = f.read(dataLength)
                print '[t += %.4d]: %s' % (msDelta, signal_repr(data))
    except EOFError:
        pass


def mouse_pos(data):
    (x, y) = uvarintsDecode(data)
    return '(%d, %d)' % (x, y)


def input_idle(data):
    (value,) = uvarintsDecode(data)
    return '%d' % value


def front_window(data):
    return data


if __name__ == '__main__':
    main()
