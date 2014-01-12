# IPod for students

Create cribs automatically. 

## How It Works

### Run
Template:
```shell
ruby app.rb {source} {output directory}
```

Example:
```shell
ruby app.rb cribs/math.txt cribs/math
```

### Output

You will get:
```
- {output directory}
  - {name of first crib}
    - 1.gif
  - {name of second crib}
    - 1.gif
    - 2.gif
    - ...
```

### Source

Template:
```text
{name of first crib folder}
{text of first crib}
////
{name of second crib folder}
{text of second crib}
```

Example:
```text
Love
I love my teacher
////
Future
I passed the exam
```
