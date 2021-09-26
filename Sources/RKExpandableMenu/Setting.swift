//
//  File.swift
//  
//
//  Created by Reza Khonsari on 8/23/21.
//

import UIKit

public struct Setting {
    
    public static let `default` = Setting()
    
    public var smallImageSize: CGFloat = 24
    public var horizontalInset: CGFloat = 16
    public var cellSize: CGFloat = 44
    public var selectedImageSide: SelectedImageSide = .onLeft
    public var defaultSelectedImage: UIImage = UIImage(named: "tick", in: .module, compatibleWith: nil)!
    public var defaultUnSelectedImage: UIImage? = nil
    public var numberOfShownCell: Int = 3
    public var isDismissibleBySelection: Bool = true
    public var leadingImageSize: CGFloat = 24
    
    public enum SelectedImageSide {
        case onLeft, onRight
    }
    
    public init(smallImageSize: CGFloat = 24, horizontalInset: CGFloat = 16, cellSize: CGFloat = 44, selectedImageSide: Setting.SelectedImageSide = .onLeft, numberOfShownCell: Int = 3, isDismissibleBySelection: Bool = true, leadingImageSize: CGFloat = 24) {
        self.smallImageSize = smallImageSize
        self.horizontalInset = horizontalInset
        self.cellSize = cellSize
        self.selectedImageSide = selectedImageSide
        self.numberOfShownCell = numberOfShownCell
        self.isDismissibleBySelection = isDismissibleBySelection
        self.leadingImageSize = leadingImageSize
    }
}

extension UIImage {
    var tickImage: UIImage { UIImage(named: "tick", in: .module, compatibleWith: nil)! }
}
