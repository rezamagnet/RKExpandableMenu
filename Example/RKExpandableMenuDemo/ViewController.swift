//
//  ViewController.swift
//  RKExpandableMenuDemo
//
//  Created by Reza Khonsari on 8/22/21.
//

import UIKit
import RKExpandableMenu

class ViewController: UIViewController {
    
    var expandableMenuView = RKExpandableMenuView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Setting.selectedImageSide = .onRight
        expandableMenuView.separatorStyle = .none
        view.addSubview(expandableMenuView)
        expandableMenuView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            expandableMenuView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            expandableMenuView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            expandableMenuView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            expandableMenuView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        
        
        
        let item = RKExpandableRowItemModel(isSelected: false, title: "Test1") {
            
        }
        
        let itemTwo = RKExpandableRowItemModel(isSelected: false, title: "Test2") {
            
        }
        
        let itemThree = RKExpandableRowItemModel(isImageStable: true, isSelected: true, selectedImage: UIImage(named: "logo"), title: "Test3") {
            
        }
        
        let itemFour = RKExpandableRowItemModel(isSelected: false, title: "Test4") {
            
        }
        
        let itemFive = RKExpandableRowItemModel(isSelected: false, title: "Test5") {
            
        }
        
        let row = RKExpandableRowModel(headerTitle: "Header", headerAction: nil, items: [item, itemTwo], footerTitle: "Footer", footerTitleColor: .red, footerImage: UIImage(named: "logo"), footerAction: nil)
        
        expandableMenuView.model = row
        
        
        
    }

}


// MARK: - Add custom model
extension ViewController {
    struct RKExpandableRowModel: RKExpandableRow {
        var headerTitle: String?
        var headerAction: (() -> ())?
        var items: [RKExpandableRowItem]
        var footerTitle: String?
        var footerTitleColor: UIColor?
        var footerImage: UIImage?
        var footerAction: (() -> ())?
    }
    
    struct RKExpandableRowItemModel: RKExpandableRowItem {
        var isImageStable: Bool = false
        var isSelected: Bool
        var selectedImage: UIImage?
        var title: String
        var action: (() -> ())
    }
}
