//
//  ExpandableCellView.swift
//  Magnet
//
//  Created by Reza Khonsari on 8/22/21.
//

import UIKit

protocol ExpandableCell {
    var title: String { get }
    var selectedImage: UIImage? { get }
    var isSelected: Bool { get }
    var isImageStable: Bool { get }
}

class ExpandableCellView: UIView {
    
    typealias Model = ExpandableCell
    var model: Model? { didSet { setModel(model) } }
    
    private func setModel(_ model: Model?) {
        guard let model = model else { return }
        captionLabel.text = model.title
        tickImageView.image = model.selectedImage
        tickImageView.isHidden = !model.isSelected && model.isImageStable == false
        switch Setting.selectedImageSide {
        case .onLeft:
            rootStackView.insertArrangedSubview(tickImageView, at: .zero)
        case .onRight:
            rootStackView.insertArrangedSubview(tickImageView, at: 1)
        }
    }
    
    let captionLabel = UILabel()
    let tickImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: Setting.smallImageSize).isActive = true
        return imageView
    }()
    
    lazy var rootStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [captionLabel])
        stackView.axis = .horizontal
        stackView.spacing = .zero
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
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
    }
}
