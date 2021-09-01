//
//  ExpandableNavigationBarItemView.swift
//  Magnet
//
//  Created by Reza Khonsari on 7/3/20.
//

import UIKit

public class RKExpandableMenuView: UIView {
    static let identifier = "ExpandableCell"
    
    public typealias Model = RKExpandableRow
    public var model: Model? { didSet { setModel(model) } }
    
    private var datasource = RKExpandableRowModel() {
        didSet {
            tableView.reloadData()
            layoutIfNeeded()
        }
    }
    
    private func setModel(_ model: Model?) {
        guard let model = model else { fatalError(#function) }
        datasource = RKExpandableRowModel(
            headerTitle: model.headerTitle,
            headerAction: model.headerAction,
            items: model.items,
            footerTitle: model.footerTitle,
            footerTitleColor: model.footerTitleColor,
            footerImage: model.footerImage,
            footerAction: model.footerAction
        )
    }
    
    private lazy var myHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: .zero)
    
    public var customBackgroundColor: UIColor = .white {
        didSet {
            tableView.reloadData()
        }
    }
    
    public var separatorStyle: UITableViewCell.SeparatorStyle = .singleLine
    
    public var textAlignment: NSTextAlignment = .left { didSet { tableView.reloadData() } }
    
    public var font: UIFont = .systemFont(ofSize: 14) { didSet { tableView.reloadData() } }
    
    public var radius: CGFloat = 4 { didSet { mainView.layer.cornerRadius = radius; layoutIfNeeded() } }
    
    public var headerFont: UIFont = .boldSystemFont(ofSize: 16) { didSet { tableView.reloadData() } }
    
    var mainView = UIView()
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        return tableView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: topAnchor),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        mainView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: mainView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            myHeightConstraint
        ])
        
        tableView.separatorInset = .init(top: .zero, left: 20, bottom: .zero, right: 20)
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        tableView.separatorStyle = separatorStyle
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        mainView.clipsToBounds = true
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 3
        layer.shadowOffset = .zero
        layer.cornerRadius = radius
        
        if Setting.cellSize * CGFloat(Setting.numberOfShownCell) <= tableView.contentSize.height {
            let numberOfCells = Setting.numberOfShownCell <= datasource.items.count ? Setting.numberOfShownCell : datasource.items.count
            var headerFooterHeight: CGFloat = .zero
            
            if model?.headerTitle != nil {
                headerFooterHeight += Setting.cellSize
            }
            
            if model?.footerTitle != nil {
                headerFooterHeight += Setting.cellSize
            }
            
            myHeightConstraint.constant = (Setting.cellSize * CGFloat(numberOfCells)) + headerFooterHeight
        } else {
            myHeightConstraint.constant = tableView.contentSize.height
        }
    }
    
    public func selectRow(at index: Int) {
        guard let model = model else { fatalError("Must have model") }
        for index in model.items.indices {
            self.model?.items[index].isSelected = false
        }
        self.model?.items[index].isSelected = true
        tableView.reloadData()
    }
    
}

extension RKExpandableMenuView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = model else { fatalError("Must have model") }
        guard model.items[indexPath.row].isSelected == false else { return }
        if self.model?.items[indexPath.row].isImageStable == true {
            // No need to update isSelected
        } else {
            for index in model.items.indices {
                self.model?.items[index].isSelected = false
            }
            self.model?.items[indexPath.row].isSelected = true
            tableView.reloadData()
        }
        model.items[indexPath.row].action()
        isHidden = true
    }
}

extension RKExpandableMenuView: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerTitle = datasource.headerTitle {
            let view = UIView()
            let captionLabel = UILabel()
            view.addSubview(captionLabel)
            captionLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                captionLabel.topAnchor.constraint(equalTo: view.topAnchor),
                captionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                captionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Setting.horizontalInset),
                captionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Setting.horizontalInset)
            ])
            captionLabel.text = headerTitle
            captionLabel.textColor = .black
            view.backgroundColor = customBackgroundColor
            captionLabel.textAlignment = textAlignment
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerDidTouch))
            view.addGestureRecognizer(tapGesture)
            return view
        } else {
            return nil
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let expandableFooterMenuView = ExpandableFooterMenuView()
        expandableFooterMenuView.model = ExpandableFooterMenuModel(title: datasource.footerTitle, image: datasource.footerImage)
        expandableFooterMenuView.titleLabel.textColor = datasource.footerTitleColor
        expandableFooterMenuView.backgroundColor = customBackgroundColor
        return expandableFooterMenuView
    }
    
    @objc private func headerDidTouch() {
        datasource.headerAction?()
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if datasource.headerTitle == nil {
            return .zero
        } else {
            return Setting.cellSize
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if datasource.footerTitle == nil {
            return .zero
        } else {
            return Setting.cellSize
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Setting.cellSize
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datasource.items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BaseTableViewCell<ExpandableCellView>()
        let preferredImage: UIImage
        if let image = model?.items[indexPath.row].selectedImage {
            preferredImage = image
        } else {
            preferredImage = Setting.defaultSelectedImage
        }
        cell.content.model = ExpandableCellModel(title: datasource.items[indexPath.row].title, selectedImage: preferredImage, isSelected: datasource.items[indexPath.row].isSelected, isImageStable: datasource.items[indexPath.row].isImageStable)
        
        cell.backgroundColor = customBackgroundColor
        cell.selectionStyle = .none
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        for view in cell.subviews {
            view.removeFromSuperview()
        }
    }
    
}

extension RKExpandableMenuView {
    struct RKExpandableRowModel: RKExpandableRow {
        
        init(headerTitle: String? = nil, headerAction: (() -> ())? = nil, items: [RKExpandableRowItem], footerTitle: String? = nil, footerTitleColor: UIColor? = nil, footerImage: UIImage? = nil, footerAction: (() -> ())? = nil) {
            self.headerTitle = headerTitle
            self.headerAction = headerAction
            self.items = items
            self.footerTitle = footerTitle
            self.footerTitleColor = footerTitleColor
            self.footerImage = footerImage
            self.footerAction = footerAction
        }
        
        init() {
            self.headerTitle = nil
            self.headerAction = nil
            self.items = []
            self.footerTitle = nil
            self.footerTitleColor = nil
            self.footerImage = nil
            self.footerAction = nil
        }
        
        var headerTitle: String?
        var headerAction: (() -> ())?
        var items: [RKExpandableRowItem]
        var footerTitle: String?
        var footerTitleColor: UIColor?
        var footerImage: UIImage?
        var footerAction: (() -> ())?
    }
    
    struct ExpandableFooterMenuModel: ExpandableFooterMenu {
        var title: String?
        var image: UIImage?
    }
    
    struct ExpandableCellModel: ExpandableCell {
        var title: String
        var selectedImage: UIImage?
        var isSelected: Bool
        var isImageStable: Bool
    }
}
