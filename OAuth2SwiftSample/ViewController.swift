//
//  ViewController.swift
//  OAuth2SwiftSample
//
//  Created by 加藤 雄大 on 2015/03/15.
//  Copyright (c) 2015年 grandbig.github.io. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var auth:GTMOAuth2Authentication!
    let kKeychainItemName:String! = "GOAuthTest"
    let scope:String! = "https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/calendar"
    let clientId:String! = "579581429599-e0d6008vpvfmfah1kqmbv6tp9dgs3fbf.apps.googleusercontent.com"
    let clientSecret:String! = "qdjd7HVsqA3Fk9qzSx5nMXuR"
    let hasLoggedIn:String! = "hasLoggedInKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.startLogIn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func startLogIn() {
        let defaults:NSUserDefaults? = NSUserDefaults.standardUserDefaults()
        let hasLoggedInFlag:Bool! = defaults?.boolForKey(hasLoggedIn as String)
        
        if(hasLoggedInFlag == true) {
            // 認証したことがある場合
            self.auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName("Google", clientID: clientId, clientSecret: clientSecret)
            
            // アクセストークンの取得
            self.authorizeRequest()
        } else {
            // 認証したことがない場合
            let gvc:GTMOAuth2ViewControllerTouch! = GTMOAuth2ViewControllerTouch(scope: scope, clientID: clientId, clientSecret: clientSecret, keychainItemName: "Google", delegate: self, finishedSelector: #selector(ViewController.viewController(_:finishedWithAuth:error:)))
            self.presentViewController(gvc, animated: true, completion: nil)
        }
    }
    
    func viewController(viewController:GTMOAuth2ViewControllerTouch!, finishedWithAuth:GTMOAuth2Authentication!, error:NSError?) {
        if(error != nil) {
            // 認証失敗
        } else {
            // 認証成功
            self.auth = finishedWithAuth
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(true, forKey: hasLoggedIn as String)
            defaults.synchronize()
            
            // アクセストークンの取得
            self.authorizeRequest()
        }
        
        // 認証画面を閉じる
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func authorizeRequest() {
        print(self.auth)
        let req:NSMutableURLRequest! = NSMutableURLRequest(URL: self.auth.tokenURL)
        self.auth.authorizeRequest(req, completionHandler: { (error) -> Void in
            print(self.auth)
        })
    }
}

