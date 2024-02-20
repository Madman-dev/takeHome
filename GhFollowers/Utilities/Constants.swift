//
//  Constants.swift
//  GhFollowers
//
//  Created by Porori on 2/16/24.
//

import UIKit

enum SFSymbols {
    static let location = "mappin.and.ellipse"
    static let repos = "folder"
    static let gist = "text.alignleft"
    static let followers = "heart"
    static let following = "person.2"
}

enum ScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let maxHeight = max(ScreenSize.width, ScreenSize.height)
    static let maxLength = min(ScreenSize.width, ScreenSize.height)
}

enum DeviceType {
    static let idiom = UIDevice.current.userInterfaceIdiom
    static let nativeScale = UIScreen.main.nativeScale
    static let scale = UIScreen.main.scale
    
    static let isiPhoneSE = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhone8Standard = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    // when iPhone8 is zoomed, the size is equal to iPhoneSE, Xcode interprets as so
    static let isiPhone8Zoomed = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard = idiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
    static let isiPhoneX = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr = idiom == .phone && ScreenSize.maxLength == 896.0
    static let isiPad = idiom == .pad && ScreenSize.maxLength >= 1024.0
    
    static func isIphoneXAspectRatio() -> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXr
    }
    
}
