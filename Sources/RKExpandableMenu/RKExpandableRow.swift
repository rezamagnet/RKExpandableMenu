//
//  RKExpandableRow.swift
//  
//
//  Created by Reza Khonsari on 8/22/21.
//

import UIKit

public protocol RKExpandableRow {
    var headerTitle: String? { get }
    var headerAction: (() -> ())? { get set }
    var items: [RKExpandableRowItem] { get set }
    var footerTitle: String? { get }
    var footerTitleColor: UIColor? { get }
    var footerImage: UIImage? { get }
    var footerAction: (() -> ())? { get set }
}

public protocol RKExpandableRowItem {
    var id: String { get }
    var isSelected: Bool { get set }
    var selectedImage: UIImage? { get }
    var isImageStable: Bool { get }
    var title: String { get }
    var image: UIImage? { get }
    var action: (() -> ()) { get }
}

public extension RKExpandableRowItem {
    var id: String { "" }
}
