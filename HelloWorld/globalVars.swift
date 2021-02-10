//
//  globalVars.swift
//  ep_test1
//
//  Created by ep on 10.02.2021.
//

import Foundation

class UDvars{
    
    var AppLaunch: Int = UserDefaults.standard.object(forKey: "AppLaunch") as? Int ?? 0{
        didSet{
            UserDefaults.standard.set(AppLaunch, forKey: "AppLaunch")
            UserDefaults.standard.synchronize();
        }
    }

    var Manual: Bool = UserDefaults.standard.object(forKey: "Manual") as? Bool ?? false{
        didSet{
            UserDefaults.standard.set(Manual, forKey: "Manual")
            UserDefaults.standard.synchronize();
        }
    }

    var Length: Int = UserDefaults.standard.object(forKey: "Length") as? Int ?? 6{
        didSet{
            UserDefaults.standard.set(Length, forKey: "Length")
            UserDefaults.standard.synchronize();
        }
    }
    
    var Duration: Float = UserDefaults.standard.object(forKey: "Duration") as? Float ?? 0.5{
        didSet{
            UserDefaults.standard.set(Duration, forKey: "Duration")
            UserDefaults.standard.synchronize();
        }
    }

}

let globalVars = UDvars()
