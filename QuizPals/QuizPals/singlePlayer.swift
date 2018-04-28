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
    @IBOutlet weak var answerA: UILabel!
    @IBOutlet weak var answerB: UILabel!
    @IBOutlet weak var answerC: UILabel!
    @IBOutlet weak var answerD: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var numQuestions = 0
        var questions = [[String:Any]]()
        // Do any additional setup after loading the view.
        
        let urlString = "http:www.people.vcu.edu/~ebulut/jsonFiles/quiz1.json"
        let quizurl = URL(string: urlString)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: quizurl!, completionHandler: { (data, response, error) -> Void in
            
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
        
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
