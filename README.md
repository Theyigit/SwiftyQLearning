# Q-Learning with Swift

[![Twitter: @ThisYigit](https://img.shields.io/badge/contact-@ThisYigit-blue.svg?style=flat)](https://twitter.com/ThisYigit)
[![Language](https://img.shields.io/badge/swift-3.0-orange.svg)](https://developer.apple.com/swift)
[![License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](http://mit-license.org)
[![Platform](http://img.shields.io/badge/platform-ios-lightgrey.svg?style=flat)](https://developer.apple.com/resources/)

SwiftyQlearning is a [Q-learning algorithm](https://en.wikipedia.org/wiki/Q-learning) that find the exit path of a maze on iOS.

### Preview
<p align="center">
 <img src="https://s10.postimg.org/fwubbqv4p/ilkdeneme.gif"  height="400" alt="q-learning"/>
 </p>
 
 
## USAGE

SwiftyQLearning use a .txt file for maze information. User make three inputs that start room, exit room and iteration according to room size of maze. Algorithm succeed how big iteration is. 

### Input Style

There is a file called as input.txt in project documentary. When you click input.txt, format should be something like that:
<p align="center">
<img src="https://s18.postimg.org/4r9r3ds95/input_style.png" width="400" height="385" /><img src="https://s18.postimg.org/vdm7scwg9/maze.png" width="400" height="400" alt="q-learning maze" />
 </p>
You can make many variants of maze like this format.

### Output Style

After calculate, algorithm makes animation like see also there are three output file that showed file's paths in terminal after application run. These texts show rMatrix, qMatrix and path from start to end as conclusion.

## License

SwiftyQLearning is distributed under the MIT license. [See LICENSE](http://mit-license.org) for details.
