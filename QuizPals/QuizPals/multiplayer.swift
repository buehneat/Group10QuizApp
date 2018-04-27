//
//  multiplayer.swift
//  QuizPals
//
//  Created by Aaron Buehne on 4/27/18.
//  Copyright © 2018 group10. All rights reserved.
//

import UIKit
import CoreMotion
import MultipeerConnectivity

class multiplayer: UIViewController {
    
    var session: MCSession!
    var peerID: MCPeerID!
    
    var browser: MCBrowserViewController!
    var assistant: MCAdvertiserAssistant!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
