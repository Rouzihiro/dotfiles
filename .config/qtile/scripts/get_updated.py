#!/run/current-system/sw/bin/python
import os.path
from datetime import datetime


def get_last_updated():
    lock_file = f"{os.path.expanduser('~')}/.dotfiles/flake.lock"
    updated = datetime.fromtimestamp(os.path.getmtime(lock_file))
    today = datetime.now()
    last_updated = (today - updated).days
    if last_updated == 1:
        print(f'{last_updated} day')
    else:
        print(f'{last_updated} days')


if __name__ == '__main__':
    get_last_updated()
    
