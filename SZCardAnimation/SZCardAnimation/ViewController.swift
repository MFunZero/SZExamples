//
//  ViewController.swift
//  SZCardAnimation
//
//  Created by Shuze Pang on 2017/3/31.
//  Copyright © 2017年 suze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnClicked(_ sender: SlideDownView) {
       sender.offBulb()
    }

}

