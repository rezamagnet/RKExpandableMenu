//
//  ExpandableFooterMenuView.swift
//  Magnet
//
//  Created by Reza Khonsari on 8/21/21.
//

import UIKit

protocol ExpandableFooterMenu {
    var title: String? { get }
    var image: String? { get }
}

class ExpandableFooterMenuView: UIView {

    private var imageView = UIImageView()
    private var titleLabel = UILabel()
    
    private lazy var rootStackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
    
    typealias Model = ExpandableFooterMenu
    var model: Model? { didSet {} }
    
    private func setModel(_ model: Model?) {
        guard let model = model else { fatalError() }
        titleLabel.text = model.title
        if let image = model.image {
            imageView.image = UIImage(named: image)
        } else {
            imageView.isHidden = true
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
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
    }

}
