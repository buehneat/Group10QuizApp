//
//  singlePlayer.swift
//  QuizPals
//
//  Created by Aaron Buehne on 4/27/18.
//  Copyright © 2018 group10. All rights reserved.
//

import UIKit

class singlePlayer: UIViewController {
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerA: UIButton!
    @IBOutlet weak var answerB: UIButton!
    @IBOutlet weak var answerC: UIButton!
    @IBOutlet weak var answerD: UIButton!
    
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    var taps = 0;
    var numQuestions = 0
    var questions = [[String:Any]]()
    let session = URLSession.shared
    var correctAnswer = "F"
    var choiceA = "Label"
    var choiceB = "Label"
    var choiceC = "Label"
    var choiceD = "Label"
    var timer = Timer()
    var time = 20
    var nextTime = -1
    let urls = ["http:www.people.vcu.edu/~ebulut/jsonFiles/quiz1.json", "http:www.people.vcu.edu/~ebulut/jsonFiles/quiz2.json", "http:www.people.vcu.edu/~ebulut/jsonFiles/quiz3.json", "http:www.people.vcu.edu/~ebulut/jsonFiles/quiz4.json", "http:www.people.vcu.edu/~ebulut/jsonFiles/quiz5.json"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the time to 40 because 2 threads are going, therefore it is going twice as fast
        
        
        answerA.titleLabel?.adjustsFontSizeToFitWidth = true;
        answerB.titleLabel?.adjustsFontSizeToFitWidth = true;
        answerC.titleLabel?.adjustsFontSizeToFitWidth = true;
        answerD.titleLabel?.adjustsFontSizeToFitWidth = true;
        
        // Do any additional setup after loading the view.
        
        
        
        getJson(urlString: urls[BuehneWork.quiz])
        
        //var quizurl = URL(string: urls[3])
        
        /*let session = URLSession.shared
        
        var task = session.dataTask(with: quizurl!, completionHandler: { (data, response, error) -> Void in
            
            do {
                print("Reading JSON data")
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                numQuestions = json["numberOfQuestions"] as! Int
                questions = json["questions"] as! [[String : Any]]
                self.navigationItem.title = json["topic"] as! String
                let question = questions[BuehneWork.questionCount]
                let questionSentence = question["questionSentence"]
                self.questionLabel.text = questionSentence as! String
                let options = question["options"] as! [String:String]
                self.answerA.text = "A)" + options["A"]!
                self.answerB.text = "B)" + options["B"]!
                self.answerC.text = "C)" + options["C"]!
                self.answerD.text = "D)" + options["D"]!
                self.testLabel.text = "Question " + String(BuehneWork.questionCount) + "/" + String(numQuestions)
            }
            catch _{
                print("Failed")
            }
        })
        
        task.resume()*/
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
        
        time = 20
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        restartButton.titleLabel?.adjustsFontSizeToFitWidth = true
        restartButton.isHidden = true
        scoreLabel.text = String(BuehneWork.score)
    }
    
    @IBAction func clickedA(_ sender: Any) {
        if self.correctAnswer == "A" {
            BuehneWork.score = BuehneWork.score + 1
            scoreLabel.text = String(BuehneWork.score)
        }
        //self.nextQuestion()
        nextTime = 3
    }
    @IBAction func clickedB(_ sender: Any) {
        if self.correctAnswer == "B" {
            BuehneWork.score = BuehneWork.score + 1
            scoreLabel.text = String(BuehneWork.score)
        }
        //self.nextQuestion()
        nextTime = 3
    }
    @IBAction func clickedC(_ sender: Any) {
        if self.correctAnswer == "C" {
            BuehneWork.score = BuehneWork.score + 1
            scoreLabel.text = String(BuehneWork.score)
        }
        //self.nextQuestion()
        nextTime = 3
    }
    @IBAction func clickedD(_ sender: Any) {
        if self.correctAnswer == "D" {
            BuehneWork.score = BuehneWork.score + 1
            scoreLabel.text = String(BuehneWork.score)
        }
        //self.nextQuestion()
        nextTime = 3
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
        time = time - 1
        
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
            nextTime = 6
        }
    }
    
    @IBAction func nextQuiz(_ sender: Any) {
        BuehneWork.quiz = BuehneWork.quiz + 1
        BuehneWork.questionCount = 1
        self.loadView()
        self.viewDidLoad()
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
