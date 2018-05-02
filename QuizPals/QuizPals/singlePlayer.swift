//
//  singlePlayer.swift
//  QuizPals
//
//  Created by Aaron Buehne on 4/27/18.
//  Copyright © 2018 group10. All rights reserved.
//

import UIKit
import CoreMotion

class singlePlayer: UIViewController {
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerA: UIButton!
    @IBOutlet weak var answerB: UIButton!
    @IBOutlet weak var answerC: UIButton!
    @IBOutlet weak var answerD: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    var numQuestions = 0
    var questions = [[String:Any]]()
    let session = URLSession.shared
    var correctAnswer = "F"
    var choiceA = "Label"
    var choiceB = "Label"
    var choiceC = "Label"
    var choiceD = "Label"
    var timer = Timer()
    var motionTimer = Timer()
    var time = 20
    var nextTime = -1
    let urls = ["http:www.people.vcu.edu/~ebulut/jsonFiles/quiz1.json", "http:www.people.vcu.edu/~ebulut/jsonFiles/quiz2.json", "http:www.people.vcu.edu/~ebulut/jsonFiles/quiz3.json", "http:www.people.vcu.edu/~ebulut/jsonFiles/quiz4.json", "http:www.people.vcu.edu/~ebulut/jsonFiles/quiz5.json"]
    
    var Ataps = 0
    var Btaps = 0
    var Ctaps = 0
    var Dtaps = 0
    
    var grey = UIColor()
    
    let motionmanager = CMMotionManager()
    
    var gotSelection = false
    
    var startPitch = 0.0
    var startYaw = 0.0
    var startRoll = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
        
        grey = answerA.backgroundColor!
        
        answerA.titleLabel?.adjustsFontSizeToFitWidth = true;
        answerB.titleLabel?.adjustsFontSizeToFitWidth = true;
        answerC.titleLabel?.adjustsFontSizeToFitWidth = true;
        answerD.titleLabel?.adjustsFontSizeToFitWidth = true;
        
        getJson(urlString: urls[BuehneWork.quiz])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getJson(urlString: String) {
        var quizurl = URL(string: urlString)
        
        var task = session.dataTask(with: quizurl!, completionHandler: { (data, response, error) -> Void in
            
            do {
                print("Reading JSON data")
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                self.numQuestions = json["numberOfQuestions"] as! Int
                self.questions = json["questions"] as! [[String : Any]]
                self.navigationItem.title = json["topic"] as! String
                let question = self.questions[BuehneWork.questionCount - 1]
                let questionSentence = question["questionSentence"]
                self.questionLabel.text = questionSentence as! String
                let options = question["options"] as! [String:String]
                /*self.answerA.titleLabel?.text = "A)" + options["A"]!
                self.answerB.titleLabel?.text = "B)" + options["B"]!
                self.answerC.titleLabel?.text = "C)" + options["C"]!
                self.answerD.titleLabel?.text = "D)" + options["D"]!*/
                self.choiceA = "A)" + options["A"]!
                self.choiceB = "B)" + options["B"]!
                self.choiceC = "C)" + options["C"]!
                self.choiceD = "D)" + options["D"]!
                self.testLabel.text = "Question " + String(BuehneWork.questionCount) + "/" + String(self.numQuestions)
                self.correctAnswer = question["correctOption"] as! String
                
                OperationQueue.main.addOperation {
                    self.doMain()
                }
            }
            catch _{
                print("Failed")
                BuehneWork.quiz = 0
                self.getJson(urlString: self.urls[BuehneWork.quiz])
            }
        })
        
        task.resume()
        //rtask.cancel()
    }
    
    func doMain() {
        print("Doing main")
        self.answerA.setTitle(choiceA, for: UIControlState.normal)
        self.answerB.setTitle(choiceB, for: UIControlState.normal)
        self.answerC.setTitle(choiceC, for: UIControlState.normal)
        self.answerD.setTitle(choiceD, for: UIControlState.normal)
        
        self.motionmanager.deviceMotionUpdateInterval = 1.0/60.0
        self.motionmanager.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical)
        
        time = 20
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        motionTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self,   selector: (#selector(updateDeviceMotion)), userInfo: nil, repeats: true)
        restartButton.titleLabel?.adjustsFontSizeToFitWidth = true
        restartButton.isHidden = true
        scoreLabel.text = String(BuehneWork.score)
        
        
    }
    
    @IBAction func clickedA(_ sender: Any) {
        setGrey()
        Btaps = 0
        Ctaps = 0
        Dtaps = 0
        Ataps = Ataps + 1
        if self.correctAnswer == "A" && Ataps == 2{
            BuehneWork.score = BuehneWork.score + 1
            scoreLabel.text = String(BuehneWork.score)
        }
        if Ataps == 1 {
            answerA.backgroundColor = UIColor.green
        }
        if Ataps == 2{
            nextTime = 3
            answerA.backgroundColor = UIColor.blue
        }
    }
    @IBAction func clickedB(_ sender: Any) {
        setGrey()
        Ataps = 0
        Ctaps = 0
        Dtaps = 0
        Btaps = Btaps + 1
        if self.correctAnswer == "B" && Btaps == 2{
            BuehneWork.score = BuehneWork.score + 1
            scoreLabel.text = String(BuehneWork.score)
        }
        if Btaps == 1 {
            answerB.backgroundColor = UIColor.green
        }
        if Btaps == 2{
            nextTime = 3
            answerB.backgroundColor = UIColor.blue
        }
    }
    @IBAction func clickedC(_ sender: Any) {
        setGrey()
        Btaps = 0
        Ataps = 0
        Dtaps = 0
        Ctaps = Ctaps + 1
        if self.correctAnswer == "C" && Ctaps == 2{
            BuehneWork.score = BuehneWork.score + 1
            scoreLabel.text = String(BuehneWork.score)
        }
        if Ctaps == 1 {
            answerC.backgroundColor = UIColor.green
        }
        if Ctaps == 2{
            nextTime = 3
            answerC.backgroundColor = UIColor.blue
        }
    }
    @IBAction func clickedD(_ sender: Any) {
        setGrey()
        Btaps = 0
        Ctaps = 0
        Ataps = 0
        Dtaps = Dtaps + 1
        if self.correctAnswer == "D" && Dtaps == 2{
            BuehneWork.score = BuehneWork.score + 1
            scoreLabel.text = String(BuehneWork.score)
        }
        if Dtaps == 1 {
            answerD.backgroundColor = UIColor.green
        }
        if Dtaps == 2{
            nextTime = 3
            answerD.backgroundColor = UIColor.blue
        }
    }
    
    func nextQuestion() {
        if BuehneWork.questionCount < numQuestions {
            BuehneWork.questionCount = BuehneWork.questionCount + 1
            self.loadView()
            self.viewDidLoad()
        }
        else {
            scoreLabel.text = "You Win!"
            restartButton.isHidden = false
            timer.invalidate()
        }
    }
    
    @objc func updateTimer() {
        if time == 120 {
            if let motionData = self.motionmanager.deviceMotion {
                let attitude = motionData.attitude
                
                startYaw = attitude.yaw
                startRoll = attitude.roll
                startPitch = attitude.pitch
                print(startYaw)
            }
        }
        time = time - 1
        if time >= 0 && nextTime < 0{
            timeLabel.text = String(time)
        }
        
        if nextTime > 0 {
            nextTime = nextTime - 1
            questionLabel.text = "The correct answer was: " + correctAnswer
            answerA.isUserInteractionEnabled = false
            answerB.isUserInteractionEnabled = false
            answerC.isUserInteractionEnabled = false
            answerD.isUserInteractionEnabled = false
        }
        else if nextTime == 0 {
            nextTime = -1
            nextQuestion()
        }
        
        if time == 0 {
            nextTime = 3
        }
        
    }
    
    @IBAction func nextQuiz(_ sender: Any) {
        BuehneWork.quiz = BuehneWork.quiz + 1
        BuehneWork.questionCount = 1
        self.loadView()
        self.viewDidLoad()
    }
    
    func setGrey(){
        answerA.backgroundColor = grey
        answerB.backgroundColor = grey
        answerC.backgroundColor = grey
        answerD.backgroundColor = grey
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("Shaked")
            if self.nextTime < 0
            {
                while (!gotSelection)
                {
                    var selection = Int(arc4random()) % 4
                    if selection == 0 && Ataps == 0 {
                        gotSelection = true
                        self.clickedA(self.answerA)
                    }
                    if selection == 1 && Btaps == 0 {
                        gotSelection = true
                        self.clickedB(self.answerB)
                    }
                    if selection == 2 && Ctaps == 0 {
                        gotSelection = true
                        self.clickedC(self.answerC)
                    }
                    if selection == 3 && Dtaps == 0 {
                        gotSelection = true
                        self.clickedD(self.answerD)
                    }
                }
                gotSelection = false
            }
            
        }
    }
    
    @objc func updateDeviceMotion() {
        if let motionData = self.motionmanager.deviceMotion {
            let attitude = motionData.attitude
            
            let gravity = motionData.gravity
            let rotation = motionData.rotationRate
            
            
            if Ataps == 1 || Btaps == 1 || Ctaps == 1 || Dtaps == 1 {
                if (attitude.roll) >= 1.0{
                    if Ataps == 1 {
                        self.clickedB(self.answerB)
                        print("Rolled Right from A")
                        print("Pitch: \(attitude.pitch), roll: \(attitude.roll), yaw: \(attitude.yaw)")
                    }
                    if Ctaps == 1 {
                        self.clickedD(self.answerD)
                        print("Rolled Right from C")
                        print("Pitch: \(attitude.pitch), roll: \(attitude.roll), yaw: \(attitude.yaw)")
                    }
                }
                if (attitude.roll) <= -1.0{
                    if Btaps == 1 {
                        self.clickedA(self.answerA)
                        print("Rolled left from B")
                        print("Pitch: \(attitude.pitch), roll: \(attitude.roll), yaw: \(attitude.yaw)")
                    }
                    if Dtaps == 1 {
                        self.clickedC(self.answerC)
                        print("Rolled left from D")
                        print("Pitch: \(attitude.pitch), roll: \(attitude.roll), yaw: \(attitude.yaw)")
                    }
                }
                if (attitude.pitch) >= 1.0{
                    if Ataps == 1 {
                        self.clickedC(self.answerC)
                        print("Pitch down from A")
                        print(startPitch)
                        print("Pitch: \(attitude.pitch), roll: \(attitude.roll), yaw: \(attitude.yaw)")
                    }
                    if Btaps == 1 {
                        self.clickedD(self.answerD)
                        print("Pitched down from B")
                        print("Pitch: \(attitude.pitch), roll: \(attitude.roll), yaw: \(attitude.yaw)")
                    }
                }
                if (attitude.pitch) <= -1.0{
                    if Ctaps == 1 {
                        self.clickedA(self.answerA)
                        print("Pitched up from C")
                        print("Pitch: \(attitude.pitch), roll: \(attitude.roll), yaw: \(attitude.yaw)")
                    }
                    if Dtaps == 1 {
                        self.clickedB(self.answerB)
                        print("Pitched up from D")
                        print("Pitch: \(attitude.pitch), roll: \(attitude.roll), yaw: \(attitude.yaw)")
                    }
                }
                if (attitude.yaw - startYaw) >= 1.0 || (attitude.yaw - startYaw) <= -1.0 {
                    print(attitude.yaw - startYaw)
                    if Ataps == 1 {
                        self.clickedA(self.answerA)
                        print("A: Pitch: \(attitude.pitch), roll: \(attitude.roll), yaw: \(attitude.yaw)")
                    }
                    if Btaps == 1 {
                        self.clickedB(self.answerB)
                        print("B: Pitch: \(attitude.pitch), roll: \(attitude.roll), yaw: \(attitude.yaw)")
                    }
                    if Ctaps == 1 {
                        self.clickedC(self.answerC)
                        print("C: Pitch: \(attitude.pitch), roll: \(attitude.roll), yaw: \(attitude.yaw)")
                    }
                    if Dtaps == 1 {
                        self.clickedD(self.answerD)
                        print("D: Pitch: \(attitude.pitch), roll: \(attitude.roll), yaw: \(attitude.yaw)")
                    }
                }
            }
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
