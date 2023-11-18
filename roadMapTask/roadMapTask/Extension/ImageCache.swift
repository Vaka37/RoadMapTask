//
//  ImageCache.swift
//  roadMapTask
//
//  Created by Kalandarov Vakil on 18.11.2023.
//

import Foundation
import UIKit

final class ImageCache {
    
    static var shared = ImageCache()
    
    var cache = NSCache<NSString, UIImage>()
    
    func push(image: UIImage, key: NSString){
        cache.setObject(image, forKey: key)
    }
    
    func getImage(key: NSString) -> UIImage?{
        return cache.object(forKey: key)
    }
}
