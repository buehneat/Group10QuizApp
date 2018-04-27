//
//  ViewController.swift
//  QuizPals
//
//  Created by Aaron Buehne on 4/24/18.
//  Copyright © 2018 group10. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var startQuizButton: UIButton!
    @IBOutlet weak var gameType: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        startQuizButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        
        navigationItem.rightBarButtonItem?.title = "Connect";
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "HighScores", style: .plain, target: self, action: #selector(connectPeers))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func connectPeers() {
        
    }
    
    @IBAction func Start(_ sender: Any) {
        if gameType.selectedSegmentIndex == 0 {
            let viewController = storyboard?.instantiateViewController(withIdentifier: "single")
            self.navigationController?.pushViewController(viewController!, animated: true)
        }
        else {
            let viewController = storyboard?.instantiateViewController(withIdentifier: "multi")
            self.navigationController?.pushViewController(viewController!, animated: true)
        }
    }
    


}

