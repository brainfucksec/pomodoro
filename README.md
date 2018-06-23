# pomodoro

[Pomodoro technique](https://en.wikipedia.org/wiki/Pomodoro_Technique) counter for study sessions.

## Install

### Create `bin` directory in your home
```bash
mkdir $HOME/bin
```

### Copy `pomodoro.sh` and `fs.png` files in the `bin` directory
```bash
cp -v pomodoro.sh $HOME/bin/pomodoro
cp -v fs.png $HOME/bin
```

## Usage

### Start pomodoro counter:
```bash
pomodoro --pomodoros 4
```

### Show pomodoros completed
```bash
pomodoro --list
```

### Delete pomodoros list
```bash
pomodoro --delete
```

### Show help menù
```bash
pomodoro --help
```
