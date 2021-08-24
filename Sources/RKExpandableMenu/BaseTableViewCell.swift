//
//  BaseTableViewCell.swift
//  Magnet
//
//  Created by Reza Khonsari on 4/28/21.
//

import UIKit

public class BaseTableViewCell<Content: UIView>: UITableViewCell {
    
    public lazy var content = Content()
    
    public var inset: UIEdgeInsets = .zero
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            guard content.superview == nil else { return }
            addSubview(content)
            content.clipsToBounds = true
            contentView.isHidden = true
            content.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                content.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset.left),
                content.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset.right),
                content.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset.bottom),
                content.topAnchor.constraint(equalTo: topAnchor, constant: inset.top)
            ])
        } else {
            content.removeFromSuperview()
        }
    }
    
}
