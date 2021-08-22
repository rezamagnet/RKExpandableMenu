//
//  RKExpandableRow.swift
//  
//
//  Created by Reza Khonsari on 8/22/21.
//

import Foundation

public protocol RKExpandableRow {
    var headerTitle: String? { get }
    var headerAction: (() -> ())? { get set }
    var items: [ExpandableItem] { get set }
    var footerTitle: String? { get }
    var footerImage: String? { get }
    var footerAction: (() -> ())? { get set }
}

public protocol RKExpandableRowItem {
    var isSelected: Bool { get }
    let title: String { get }
    let action: (() -> ()) { get }
}
