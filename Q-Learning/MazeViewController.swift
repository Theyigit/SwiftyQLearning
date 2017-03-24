//
//  MazeViewController.swift
//  Q-Learning
//
//  Created by Macbook on 14.03.2017.
//  Copyright © 2017 Yigit Yilmaz. All rights reserved.
//

import UIKit


class MazeViewController: UIViewController{
    
    var iteration:Int = 0
    var start:Int = 0
    var end:Int = 0
    var animationData = AnimationData()
    var accessor = QLearningData()
    var mazeIndexController:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = Bundle.main.path(forResource: "input", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                accessor.tempStringArray = data.components(separatedBy: .newlines)
                accessor.stringFromText = String(Array(data.characters))
                accessor.size = accessor.tempStringArray.count
                accessor.iteration = iteration
                mazeIndexController = Int(sqrt(Double(accessor.size)))
                accessor.start = start
                accessor.end = end

            } catch {
                print(error)
            }
        }
        defineLineSize()
        makeQMatrix()
        drawMaze()
        
    }
    
    // Make line size according to maze's room number. Maze's size will be same without noticing maze's room count.
    func defineLineSize() -> Int{

        animationData.lineSize = 300 / mazeIndexController
        
        return animationData.lineSize
    }
    
    func defineBeginCoordinates() -> Int{
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        animationData.pathBeginX = Int(screenWidth / 2) - (animationData.lineSize * mazeIndexController / 2)

        return animationData.pathBeginX
    }
    
    func drawMaze(){ // With this function draw the maze's different sides and inner lines.
        
        var index = 0
        let rMatrix = makeQMatrix().0
        
        animationData.pathBeginX = defineBeginCoordinates()
        //MARK: - Left of the Maze
        while index < mazeIndexController{
            let lineView = UIView(frame: CGRect(x: animationData.pathBeginX, y: animationData.pathBeginY, width: 3, height: animationData.lineSize))
            lineView.layer.borderWidth = 4.0
            lineView.layer.borderColor = UIColor.black.cgColor
            self.view.addSubview(lineView)
            animationData.pathBeginY = animationData.pathBeginY + animationData.lineSize
            index += 1
        }
        
        //MARK: - Bottom of the Maze
        index = 0
        while index < mazeIndexController  {
            let lineView = UIView(frame: CGRect(x: animationData.pathBeginX, y: animationData.pathBeginY, width: animationData.lineSize + 3, height: 3))
            
            if accessor.size - ( mazeIndexController - index) != end && accessor.size - ( mazeIndexController - index) != start{
                lineView.layer.borderWidth = 4.0
                lineView.layer.borderColor = UIColor.black.cgColor
                self.view.addSubview(lineView)
                
            }
            
            animationData.pathBeginX = animationData.pathBeginX + animationData.lineSize
            index += 1
        }
        
        
        //MARK: - Top of the Maze
        index = 0
        animationData.pathBeginX = defineBeginCoordinates()
        animationData.pathBeginY = 200
        while index < mazeIndexController{
            let lineView = UIView(frame: CGRect(x: animationData.pathBeginX, y: animationData.pathBeginY, width: animationData.lineSize , height: 3))
            
            if index != start && index != end{
                lineView.layer.borderWidth = 4.0
                lineView.layer.borderColor = UIColor.black.cgColor
                self.view.addSubview(lineView)

            }
            
            animationData.pathBeginX = animationData.pathBeginX + animationData.lineSize
            index += 1
        }
        
        //MARK: - Right of the Maze
        index = 0
        while index < mazeIndexController{
            let lineView = UIView(frame: CGRect(x: animationData.pathBeginX, y: animationData.pathBeginY, width: 3, height: animationData.lineSize))
            lineView.layer.borderWidth = 4.0
            lineView.layer.borderColor = UIColor.black.cgColor
            self.view.addSubview(lineView)
            animationData.pathBeginY = animationData.pathBeginY + animationData.lineSize
            index += 1
        }
        //MARK:
        
        //MARK: Make maze's inner vertical borders
        index = 0
        var counter = 1
        
        animationData.pathBeginY = 200
        
        animationData.pathBeginX = defineBeginCoordinates()
        
        while index < accessor.size {
            //print(animationData.pathBeginY)
            if counter != mazeIndexController{
                
                animationData.pathBeginX = animationData.pathBeginX + animationData.lineSize
                if rMatrix[index,index+1] == -1{
                    
                    let lineView = UIView(frame: CGRect(x: animationData.pathBeginX, y: animationData.pathBeginY, width: 3, height: animationData.lineSize))
                    lineView.layer.borderWidth = 4.0
                    lineView.layer.borderColor = UIColor.black.cgColor
                    self.view.addSubview(lineView)
                    
                    
                }
                counter += 1
            }else{
                animationData.pathBeginX = defineBeginCoordinates()
                animationData.pathBeginY = animationData.pathBeginY + animationData.lineSize
                counter = 1
                
            }
            index += 1
            
        }
        //MARK:
        
        
        //MARK: Make maze's inner horizantal borders
        index = 0
        counter = 0
        animationData.pathBeginY = 200
        animationData.pathBeginY = animationData.pathBeginY + animationData.lineSize
        animationData.pathBeginX = defineBeginCoordinates()
        
        while index < accessor.size - mazeIndexController {
           
            
            if counter <= mazeIndexController{
                
                if rMatrix[index, index + mazeIndexController] == -1{
                    
                    let lineView = UIView(frame: CGRect(x: animationData.pathBeginX, y: animationData.pathBeginY, width: animationData.lineSize, height: 3))
                    lineView.layer.borderWidth = 4.0
                    lineView.layer.borderColor = UIColor.black.cgColor
                    self.view.addSubview(lineView)
                    
                }
                animationData.pathBeginX = animationData.pathBeginX + animationData.lineSize
                
                if counter == mazeIndexController - 1 {
                    animationData.pathBeginX = defineBeginCoordinates()
                    animationData.pathBeginY = animationData.pathBeginY + animationData.lineSize
                    counter = 0
                    
                
                }else{
                    counter += 1
                }
            
                
            }


            index += 1
            
        }
        //MARK:

        
    }
    
    func makePath(){ // Draw the finding path with animation
        animationData.pathBeginY = 200
        animationData.pathBeginX = 50
        let coordinateMatrix = defineRoomsCoordinates()
        let path = findThePath()
        let borderSize = animationData.lineSize * mazeIndexController
        let startPointX = start * animationData.lineSize + animationData.pathBeginX + animationData.lineSize / 2
        let startPointY = animationData.pathBeginY
        var endPointY = animationData.lineSize / 2
        var endPointX = 0
        var index = 0
        var delayCounter = 0.2
        
        
        while index < path.count{
            var theWayToGo = path[index]
            
            if index == 0{
                if start < mazeIndexController{
                    let lineView = UIView(frame: CGRect(x: Int(coordinateMatrix[start,0]), y: Int(coordinateMatrix[start,1]) - animationData.lineSize / 2, width: 3, height: endPointY))
                    lineView.layer.borderWidth = 4.0
                    lineView.layer.borderColor = UIColor.red.cgColor
                    lineView.alpha = 0
                    UIView.animate(withDuration: 0.0, delay:delayCounter, options: .curveLinear, animations: {
                        lineView.alpha = 1
                        self.view.addSubview(lineView)
                        delayCounter += 0.7
                    })
                    endPointY = animationData.lineSize / 2 + Int(coordinateMatrix[start,1]) - animationData.lineSize / 2
                }else{
                    let lineView = UIView(frame: CGRect(x: Int(coordinateMatrix[start,0]), y: Int(coordinateMatrix[start,1]) + animationData.lineSize / 2, width: 3, height: endPointY * -1))
                    lineView.layer.borderWidth = 4.0
                    lineView.layer.borderColor = UIColor.red.cgColor
                    lineView.alpha = 0
                    UIView.animate(withDuration: 0.0, delay:delayCounter, options: .curveLinear, animations: {
                        lineView.alpha = 1
                        self.view.addSubview(lineView)
                        delayCounter += 0.7
                    })
                    endPointY = Int(coordinateMatrix[start,1]) + animationData.lineSize / 2 - animationData.lineSize / 2
                }

                
                endPointX = Int(coordinateMatrix[start,0])
                
            }else if index != 0 && index != path.count{
                if Int(coordinateMatrix[theWayToGo,0]) != endPointX{
                    
                    if Int(coordinateMatrix[theWayToGo,0]) < endPointX{
                        let lineView = UIView(frame: CGRect(x: endPointX + 3, y: endPointY, width: animationData.lineSize * -1, height: 3))
                        lineView.layer.borderWidth = 4.0
                        lineView.layer.borderColor = UIColor.red.cgColor
                        lineView.alpha = 0.0
                        UIView.animate(withDuration: 0.0, delay:delayCounter, options: .curveLinear, animations: {
                            lineView.alpha = 1
                            self.view.addSubview(lineView)
                            delayCounter += 0.7
                        })
                    }else{
                        let lineView = UIView(frame: CGRect(x: endPointX, y: endPointY, width: animationData.lineSize, height: 3))
                        lineView.layer.borderWidth = 4.0
                        lineView.layer.borderColor = UIColor.red.cgColor
                        lineView.alpha = 0
                        UIView.animate(withDuration: 0.0, delay:delayCounter, options: .curveLinear, animations: {
                            lineView.alpha = 1
                            self.view.addSubview(lineView)
                            delayCounter += 0.7
                        })
                    }

                    
                    endPointX = Int(coordinateMatrix[theWayToGo,0])
                    endPointY = Int(coordinateMatrix[theWayToGo,1])
                }else{
                    if Int(coordinateMatrix[theWayToGo,1]) < endPointY{
                        let lineView = UIView(frame: CGRect(x: endPointX, y: endPointY + 3, width: 3, height: animationData.lineSize * -1))
                        lineView.layer.borderWidth = 4.0
                        lineView.layer.borderColor = UIColor.red.cgColor
                        lineView.alpha = 0
                        UIView.animate(withDuration: 0.0, delay:delayCounter, options: .curveLinear, animations: {
                            lineView.alpha = 1
                            self.view.addSubview(lineView)
                            delayCounter += 0.7
                        })
                    }else{
                        let lineView = UIView(frame: CGRect(x: endPointX , y: endPointY, width: 3, height: animationData.lineSize))
                        lineView.layer.borderWidth = 4.0
                        lineView.layer.borderColor = UIColor.red.cgColor
                        lineView.alpha = 0
                        UIView.animate(withDuration: 0.0, delay:delayCounter, options: .curveLinear, animations: {
                            lineView.alpha = 1
                            self.view.addSubview(lineView)
                            delayCounter += 0.7
                        })
                    }

                    
                    endPointX = Int(coordinateMatrix[theWayToGo,0])
                    endPointY = Int(coordinateMatrix[theWayToGo,1])
                }
            }
            if index == path.count - 1{
                
                if end > mazeIndexController{
                    let lineView = UIView(frame: CGRect(x: endPointX, y: endPointY, width: 3, height: animationData.lineSize / 2))
                    lineView.layer.borderWidth = 4.0
                    lineView.layer.borderColor = UIColor.red.cgColor
                    lineView.alpha = 0
                    UIView.animate(withDuration: 0.0, delay:delayCounter, options: .curveLinear, animations: {
                        lineView.alpha = 1
                        self.view.addSubview(lineView)
                        delayCounter += 0.7
                    })
                }else{
                    let lineView = UIView(frame: CGRect(x: endPointX, y: endPointY + 3, width: 3, height: (animationData.lineSize / 2) * -1))
                    lineView.layer.borderWidth = 4.0
                    lineView.layer.borderColor = UIColor.red.cgColor
                    lineView.alpha = 0
                    UIView.animate(withDuration: 0.0, delay:delayCounter, options: .curveLinear, animations: {
                        lineView.alpha = 1
                        self.view.addSubview(lineView)
                        delayCounter += 0.7
                    })
                }
                

            }
            index += 1
        }
       

    }
    
    //MARK: Define every rooms center coordinates
    @discardableResult func defineRoomsCoordinates() -> Matrix{
        animationData.pathBeginY = 200
        animationData.pathBeginX = 50
        
        var index = 0
        var index2 = 0
        var counter = 0
        
       var rMatrix = Matrix(rows: accessor.size, columns: 2)
        
        while counter < mazeIndexController{
            
            while index < mazeIndexController{
                index2 = (index * mazeIndexController) + counter
                //coordinateArray[index2].xCoordinate = animationData.pathBeginX + animationData.lineSize / 2
                rMatrix[index2,0] = Double(animationData.pathBeginX + animationData.lineSize / 2 + counter * animationData.lineSize)
                rMatrix[index2,1] = Double(animationData.pathBeginY + animationData.lineSize / 2 + index * animationData.lineSize)
                index += 1
                
            }
            index = 0
            counter += 1
        }
        
        return rMatrix
        
    }
    
    func findThePath() -> Array<Int>{
        let qMatrix = makeQMatrix().1
        var path = [Int]()
        var appendTheIndex = -1
        path.append(start)
        var temp = 0
        var index = start
        
        while index < accessor.size {
            var index2 = 0
            while index2 < accessor.size {
                if temp <= Int(qMatrix[index,index2]){
                    temp = Int(qMatrix[index,index2])
                    appendTheIndex = index2
                }
                index2 += 1
            }
            
            path.append(appendTheIndex)
            index = appendTheIndex
            if appendTheIndex == accessor.end
            {
                break
            }
            
        }
        return path
        
    }
    
    
    //MARK: - Make R-Matrix
    @discardableResult func makeRMatrixGreatAgain(string: String) -> Matrix{
        
        var rMatrix = Matrix(rows: accessor.size, columns: accessor.size)
        var index = 0
        let makeString = string.components(separatedBy: "\n")
        
        while index < makeString.count{
            
            var index2 = 0
            var makeString2 = makeString[index].components(separatedBy: ",")
            
            while index2 < makeString2.count{
                
                var variable: Int
                
                if makeString2[index2] != ""{
                    
                    variable = Int(makeString2[index2])!
                    rMatrix[index,variable] = 0
                    if variable == accessor.end{
                        rMatrix[index, variable] = 100
                        rMatrix[variable, variable] = 100
                        
                    }
                    
                }
                
                index2 += 1
            }
            index += 1
            
        }
        
        return rMatrix
        
    }
    //MARK:
    
    // MARK: Q Matrix Maker
    @discardableResult func makeQMatrix() -> (Matrix, Matrix){
        var qMatrix = Matrix(rows: accessor.size, columns: accessor.size)
        var rMatrix = makeRMatrixGreatAgain(string: accessor.stringFromText)
        var index = 0
        let coefficient = 0.8
        var r1 = accessor.start
        
        // Make QMatrix's value 0
        while index < accessor.size{
            var index2 = 0
            
            while index2 < accessor.size{
                qMatrix[index,index2] = 0
                index2 += 1
            }
            index += 1
        }
        
        // Calculate QMatrix
        for _ in 0...accessor.iteration - 1{
            
            var biggestValue = -1.0
            var r2 = Int(arc4random_uniform(UInt32(accessor.size)))
            
            var newI: Int = -1
            
            while rMatrix[r1,r2] != -1{
                
                for i in 0...accessor.size - 1{
                    if rMatrix[r2,i] != -1.0{
                        if biggestValue < qMatrix[r2,i]{
                            biggestValue = qMatrix[r2,i]
                            
                            newI = i
                        }else{
                            
                            newI = r2
                        }
                    }
                }
                if rMatrix[r1,r2] != -1.0{
                    qMatrix[r1,r2] = rMatrix[r1,r2] + coefficient * biggestValue
                    
                    r1 = r2
                    r2 = newI
                }else{
                    r1 = Int(arc4random_uniform(UInt32(accessor.size)))
                    r2 = Int(arc4random_uniform(UInt32(accessor.size)))
                }
                if rMatrix[r1,r2] == 100{
                    break
                }
                
            }
            r1 = Int(arc4random_uniform(UInt32(accessor.size)))
        }
        
        
        
        return (rMatrix,qMatrix)
        
    }
    //MARK: 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 5.0, delay:5.0, options: .curveEaseOut, animations: {
            self.makePath()
        })
        
    }
}
