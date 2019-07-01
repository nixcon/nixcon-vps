import sys
import os


module_name = 'pretix'


def main():
    os.environ['PYTHONPATH'] = ':'.join(sys.path)
    os.execv(sys.executable, [sys.executable, '-m', module_name] + sys.argv[1:])
