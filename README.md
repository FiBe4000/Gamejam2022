# Gamejam2022

## 1. Code style
Set your godot editor to 2 spaces for indentation.

### 1.1 Godot signals
When connecting signals, if it is possible to do it
statically in the GUI, do it statically. If it is not
possible, do it dynamically in the code.

## Git
Set git to use LF line endings, 
`git config --global core.autocrlf input`

### Collision layers

| Layer | Name                   |
|-------|------------------------|
| 1     | Environment            |
| 2     | Player                 |
| 3     | Enemies                |
| 4     | Projectiles (reserved) |