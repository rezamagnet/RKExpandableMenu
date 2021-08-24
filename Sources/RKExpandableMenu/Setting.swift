//
//  File.swift
//  
//
//  Created by Reza Khonsari on 8/23/21.
//

import UIKit

public enum Setting {
    static let smallImageSize: CGFloat = 24
    public static let horizontalInset: CGFloat = 16
    public static let cellSize: CGFloat = 44
    public static var selectedImageSide: SelectedImageSide = .onLeft
    public static var defaultSelectedImage: UIImage = UIImage(named: "tick", in: .module, compatibleWith: nil)!
    public static let numberOfShownCell: Int = 3
    
    public enum SelectedImageSide {
        case onLeft, onRight
    }
}
