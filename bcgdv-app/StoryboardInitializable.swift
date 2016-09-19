//
//  StoryboardInitializable.swift
//  bcgdv-app
//
//  Created by Hamon Riazy on 19/09/2016.
//  Copyright © 2016 Hamon Riazy. All rights reserved.
//

import UIKit

public protocol StoryboardInitializable {
    associatedtype T
    static func instantiate(from storyboard: UIStoryboard) -> T
}

public extension StoryboardInitializable where Self: UIViewController {
    public static func instantiate(from storyboard: UIStoryboard) -> Self {
        return storyboard.instantiateViewController(withIdentifier: String.init(describing: self)) as! Self
    }
    
    public static func instantiate(fromStoryboardNamed storyboardName: String) -> Self {
        return self.instantiate(from: UIStoryboard(name: storyboardName, bundle: nil))
    }
    
    public static func instantiateFromStoryboard() -> Self {
        return self.instantiate(from: UIStoryboard(name: "Main", bundle: nil))
    }
}

extension UIViewController: StoryboardInitializable {
    public typealias T = UIViewController
}
