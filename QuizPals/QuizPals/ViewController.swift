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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        startQuizButton.titleLabel?.adjustsFontSizeToFitWidth = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

