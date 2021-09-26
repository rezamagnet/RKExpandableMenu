//
//  ExpandableFooterMenuView.swift
//  Magnet
//
//  Created by Reza Khonsari on 8/21/21.
//

import UIKit

protocol ExpandableFooterMenu {
    var title: String? { get }
    var image: UIImage? { get }
}

class ExpandableFooterMenuView: UIView {

    var action: (() -> ()) = { }
    private var imageView = UIImageView()
    private(set) var titleLabel = UILabel()
    
    private lazy var rootStackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
    
    typealias Model = ExpandableFooterMenu
    var model: Model? { didSet { setModel(model) } }
    
    private func setModel(_ model: Model?) {
        guard let model = model else { fatalError() }
        titleLabel.text = model.title
        if let image = model.image {
            imageView.image = image
        } else {
            imageView.isHidden = true
        }
    }
    
    convenience init(setting: Setting) {
        self.init(frame: .zero)
        setup(setting: setting)
    }
    
    private func setup(setting: Setting) {
        rootStackView.isLayoutMarginsRelativeArrangement = true
        rootStackView.layoutMargins = .init(top: .zero, left: setting.horizontalInset, bottom: .zero, right: setting.horizontalInset)
        rootStackView.axis = .horizontal
        rootStackView.spacing = 8
        addSubview(rootStackView)
        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: topAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: setting.smallImageSize).isActive = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTouch))
        addGestureRecognizer(tapGesture)
    }

    @objc private func didTouch() {
        action()
    }
    
}
