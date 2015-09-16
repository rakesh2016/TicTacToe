//
//  Instructions.swift
//  attempt3
//
//  Created by Michelle Emamdie on 9/13/15.
//  Copyright © 2015 Michelle Emamdie. All rights reserved.
//

import UIKit

class Instructions: UIViewController {
    @IBOutlet var nameImage: UIImageView!
    @IBOutlet var welcomeImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeImage.image = UIImage(named: "home")
        nameImage.image = UIImage(named: "enter")
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
