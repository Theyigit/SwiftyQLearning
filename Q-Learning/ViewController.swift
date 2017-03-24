//
//  ViewController.swift
//  Q-Learning
//
//  Created by Macbook on 5.03.2017.
//  Copyright © 2017 Yigit Yilmaz. All rights reserved.
//

import UIKit



class ViewController: UIViewController{

    var modalAccessor = QLearningData()
    
    
    
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!



    @IBOutlet var iterationInput: UITextField!
    @IBOutlet var endInput: UITextField!
    @IBOutlet var startInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let path = Bundle.main.path(forResource: "input", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                modalAccessor.tempStringArray = data.components(separatedBy: .newlines)
                modalAccessor.stringFromText = String(Array(data.characters))
                modalAccessor.size = modalAccessor.tempStringArray.count
                endLabel.text = "Maximum value of exit should be \(modalAccessor.size - 1)"
                
            } catch {
                print(error)
            }
        
        startLabel.text = "Minimum value of start should be 0"
            
        }
        
        
    
    }
    // MARK: - R Matrix Maker
    @discardableResult func makeRMatrixGreatAgain(string: String) -> Matrix{

        var rMatrix = Matrix(rows: modalAccessor.size, columns: modalAccessor.size)
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
                    if variable == modalAccessor.end{
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
    // MARK: -
    // MARK: Q Matrix Maker
    @discardableResult func makeQMatrix() -> (Matrix, Matrix){
        var qMatrix = Matrix(rows: modalAccessor.size, columns: modalAccessor.size)
        var rMatrix = makeRMatrixGreatAgain(string: modalAccessor.stringFromText)
        var index = 0
        let coefficient = 0.8
        var r1 = modalAccessor.start
        
        // Make QMatrix's value 0
        while index < modalAccessor.size{
            var index2 = 0
            
            while index2 < modalAccessor.size{
                qMatrix[index,index2] = 0
                index2 += 1
            }
            index += 1
        }
        
        // Calculate QMatrix
        for _ in 0...modalAccessor.iteration - 1{
            
            var biggestValue = -1.0
            var r2 = Int(arc4random_uniform(UInt32(modalAccessor.size)))
            
            var newI: Int = -1
            
            while rMatrix[r1,r2] != -1{
                
                for i in 0...modalAccessor.size - 1{
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
                    r1 = Int(arc4random_uniform(UInt32(modalAccessor.size)))
                    r2 = Int(arc4random_uniform(UInt32(modalAccessor.size)))
                }
                if rMatrix[r1,r2] == 100{
                    break
                }
                
            }
            r1 = Int(arc4random_uniform(UInt32(modalAccessor.size)))
        }
        
        
        
        return (rMatrix,qMatrix)
        
    }
    // MARK: -
    // MARK: Find the Maze's exit path
    func findThePath() -> Array<Int>{
        let qMatrix = makeQMatrix().1
        var path = [Int]()
        var appendTheIndex = -1
        path.append(modalAccessor.start)
        var temp = 0
        var index = modalAccessor.start
        
        while index < modalAccessor.size {
            var index2 = 0
            while index2 < modalAccessor.size {
                if temp <= Int(qMatrix[index,index2]){
                    temp = Int(qMatrix[index,index2])
                    appendTheIndex = index2
                }
                index2 += 1
            }
            
            path.append(appendTheIndex)
            index = appendTheIndex
            if appendTheIndex == modalAccessor.end
            {
                break
            }
            
        }
        return path
        
    }
    // MARK: -
    
    // MARK: Write to file rMatrix, qMatrix, path
    func writeToFile(){
        
        let path = findThePath()
        let rMatrix = makeQMatrix().0
        let qMatrix = makeQMatrix().1
    
        let outPath = "outPath"
        let outR = "outR"
        let outQ = "outQ"
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let outPathfileURL = DocumentDirURL.appendingPathComponent(outPath).appendingPathExtension("txt")
        let outRfileURL = DocumentDirURL.appendingPathComponent(outR).appendingPathExtension("txt")
        let outQfileURL = DocumentDirURL.appendingPathComponent(outQ).appendingPathExtension("txt")
        print("FilePath: \(outPathfileURL.path)")
        
        let writeString = String(describing: path)
        let rMatrixString = String(describing: rMatrix)
        let qMatrixString = String(describing: qMatrix)
        do {
            // Write to the file
            try writeString.write(to: outPathfileURL, atomically: true, encoding: String.Encoding.utf8)
            try rMatrixString.write(to: outRfileURL, atomically: true, encoding: String.Encoding.utf8)
            try qMatrixString.write(to: outQfileURL, atomically: true, encoding: String.Encoding.utf8)
            
        } catch let error as NSError {
            print("Failed writing to URL: \(outPathfileURL), Error: " + error.localizedDescription)
        }
    }
    //MARK: -
    
    @IBAction func takeInputs(_ sender: UIButton) {
        
        if !(startInput.text?.isEmpty)! , !(endInput.text?.isEmpty)! , !(iterationInput.text?.isEmpty)!{
            modalAccessor.start = Int(startInput.text!)!
            modalAccessor.end = Int(endInput.text!)!
            modalAccessor.iteration = Int(iterationInput.text!)!
            
            startInput.resignFirstResponder()
            endInput.resignFirstResponder()
            iterationInput.resignFirstResponder()
            
            writeToFile()
         

        
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        let ac = UIAlertController(title: "Missing Information",
                                   message: "Start, exit and iteration fields cannot empty!",
                                   preferredStyle: .alert)
        let cancelAction = UIAlertAction (title: "OK",
                                          style: .cancel,
                                          handler: nil)
        ac.addAction(cancelAction)
        
        
        if identifier == "showAnimation" {
            
            if !(startInput.text?.isEmpty)! , !(endInput.text?.isEmpty)! , !(iterationInput.text?.isEmpty)!{
                

                
                return true
            }
                
                
            else {
                present(ac, animated: true, completion: nil)
                return false
            }
        }
        
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAnimation"{
            let animationVC = segue.destination as! MazeViewController
            animationVC.iteration = Int(iterationInput.text!)!
            animationVC.start = Int(startInput.text!)!
            animationVC.end = Int(endInput.text!)!
            
        }
    }


    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer){
        startInput.resignFirstResponder()
        endInput.resignFirstResponder()
        iterationInput.resignFirstResponder()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

