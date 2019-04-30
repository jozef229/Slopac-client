//
//  LoginNavigationController.swift
//  Slopac
//
//  Created by Jozef Varga on 19/03/2019.
//  Copyright © 2019 Jozef Varga. All rights reserved.
//

import UIKit

class LoginNavigationController: UINavigationController {
    
    var userData : [UsersCoreData]?
    override func viewDidLoad() {
        super.viewDidLoad()
        userData = DatabaseHandler.fetchDataUsers()!
        if((userData?.count)! > 0){
            performSegue(withIdentifier: "isLogin", sender: self)
        }else{
            performSegue(withIdentifier: "isNotLogin", sender: self)
        }
        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
