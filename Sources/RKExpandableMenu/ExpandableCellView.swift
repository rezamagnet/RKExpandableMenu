//
//  ExpandableCellView.swift
//  Magnet
//
//  Created by Reza Khonsari on 8/22/21.
//

import UIKit

protocol ExpandableCell {
    var image: UIImage? { get }
    var title: String { get }
    var selectedImage: UIImage? { get }
    var isSelected: Bool { get }
    var isImageStable: Bool { get }
}

open class ExpandableCellView: UIView {
    
    typealias Model = ExpandableCell
    var model: Model? { didSet { setModel(model) } }
    
    private func setModel(_ model: Model?) {
        guard let model = model else { return }
        imageView.image = model.image
        imageView.isHidden = model.image == nil
        captionLabel.text = model.title
        if model.isSelected || model.isImageStable {
            tickImageView.image = model.selectedImage
        } else {
            tickImageView.image = Setting.defaultUnSelectedImage
        }
        tickImageView.isHidden = !model.isSelected && model.isImageStable == false && Setting.defaultUnSelectedImage == nil
        switch Setting.selectedImageSide {
        case .onLeft:
            rootStackView.insertArrangedSubview(tickImageView, at: .zero)
        case .onRight:
            rootStackView.insertArrangedSubview(tickImageView, at: 1)
        }
    }
    
    let imageView = UIImageView()
    let captionLabel = UILabel()
    let tickImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: Setting.smallImageSize).isActive = true
        return imageView
    }()
    
    lazy var rootStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, captionLabel])
        stackView.axis = .horizontal
        stackView.spacing = .zero
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubview(rootStackView)
        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: topAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            rootStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        rootStackView.spacing = 4
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: Setting.leadingImageSize).isActive = true
        imageView.contentMode = .scaleAspectFit
    }
}
