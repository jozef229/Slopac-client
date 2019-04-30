//
//  MainTabBarController.swift
//  Slopac
//
//  Created by Jozef Varga on 23/12/2018.
//  Copyright © 2018 Jozef Varga. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    @IBOutlet weak var mainTabBar: UITabBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let items = mainTabBar.items else { return }
        print("ahoj")
        items[0].title = "account".localized
        items[1].title = "search".localized
        items[2].title = "favorite".localized
        items[3].title = "passes".localized
        items[4].title = "lent_barcode".localized
//        mainTabBar.select(items[0])
        
//
        
//        UITabBar.appearance().tintColor = UIColor.gray
//        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
//        self.delegate = self
    }
    
    
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        //        if(identifier == "booksSearch"){
//        //
//        //
//        //        }
//        //        else{
//        //            return false
//        //        }
//        print(identifier)
//        return true
//    }
    
    // called whenever a tab button is tapped
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//
//        if viewController is UserDetailViewController {
//            print("First tab")}
////        } else if viewController is SecondViewController {
////            print("Second tab")
////        }
//    }
    
//    private func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
//        print("llll")
//        print(viewController.title)
//        if viewController.title == "account".localized {
//            return false
//        }
//        else{
//            return true
//        }
//    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        self.tabBar.barTintColor = UIColor.init(red: 126/255, green: 0/255, blue: 64/255, alpha: 1.0)
//        if #available(iOS 10.0, *) {
//            self.tabBar.unselectedItemTintColor = UIColor.white
//            self.tabBar.unselectedItemTintColor = UIColor.white
//            
//        } else {
//            // Fallback on earlier versions
//        }
//        UITabBar.appearance().tintColor = UIColor.white
//        
//    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
