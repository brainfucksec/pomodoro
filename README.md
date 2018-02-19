# pomodoro

[Pomodoro technique](https://en.wikipedia.org/wiki/Pomodoro_Technique) counter for study sessions.

## Install

#### Create `bin` directory in your home
```bash
mkdir $HOME/bin
```

#### Copy `pomodoro` and `fs.png` files in the `bin` directory
```bash
cp -v pomodoro fs.png $HOME/bin
```

#### Chmod and run
```bash
chmod +x $HOME/bin/pomodoro

pomodoro --help
pomodoro 0.1.0
Pomodoro technique counter for study sessions.

usage: pomodoro [option]

options:
-h, --help | show this help menu
-v, --version | show program version
-p, --pomodoros [number] | number of pomodoros
-l, --list | show pomodoros completed
-d, --delete | delete pomodoros list
```
