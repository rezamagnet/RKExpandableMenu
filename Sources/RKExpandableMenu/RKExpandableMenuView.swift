//
//  ExpandableNavigationBarItemView.swift
//  Magnet
//
//  Created by Reza Khonsari on 7/3/20.
//

import UIKit

open class RKExpandableMenuView: UIView {
    static let identifier = "ExpandableCell"
    
    public var setting = Setting.default
    
    public typealias Model = RKExpandableRow
    public var model: Model? { didSet { setModel(model) } }
    
    public var items = [ExpandableCellModel]()
    
    private var datasource = RKExpandableRowModel()
    
    private func setModel(_ model: Model?) {
        guard let model = model else { fatalError(#function) }
        datasource = RKExpandableRowModel(
            headerTitle: model.headerTitle,
            headerAction: model.headerAction,
            items: [],
            footerTitle: model.footerTitle,
            footerTitleColor: model.footerTitleColor,
            footerImage: model.footerImage,
            footerAction: model.footerAction
        )
        
        items = model.items.map {
            let preferredImage: UIImage
            if let image = $0.selectedImage {
                preferredImage = image
            } else {
                preferredImage = setting.defaultSelectedImage
            }
            return ExpandableCellModel(id: $0.id, image: $0.image ,title: $0.title, selectedImage: preferredImage, isSelected: $0.isSelected, isImageStable: $0.isImageStable, action: $0.action)
        }

        tableView.reloadData()
        layoutIfNeeded()
    }
    
    private lazy var myHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: .zero)
    
    public var customBackgroundColor: UIColor = .white {
        didSet {
            tableView.backgroundColor = customBackgroundColor
            tableView.reloadData()
        }
    }
    
    public var separatorStyle: UITableViewCell.SeparatorStyle = .singleLine
    
    public var textAlignment: NSTextAlignment = .left { didSet { tableView.reloadData() } }
    
    public var font: UIFont = .systemFont(ofSize: 14) { didSet { tableView.reloadData() } }
    
    public var radius: CGFloat = 4 { didSet { mainView.layer.cornerRadius = radius; layoutIfNeeded() } }
    
    public var headerFont: UIFont = .boldSystemFont(ofSize: 16) { didSet { tableView.reloadData() } }
    
    var mainView = UIView()
    public private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
#if swift(>=5.5)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = .zero
        } else {
            // Fallback on earlier versions
        }
#endif
        return tableView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder: NSCoder) {
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
        
        if setting.cellSize * CGFloat(setting.numberOfShownCell) <= tableView.contentSize.height {
            let numberOfCells = setting.numberOfShownCell <= items.count ? setting.numberOfShownCell : items.count
            var headerFooterHeight: CGFloat = .zero
            
            if model?.headerTitle != nil {
                headerFooterHeight += setting.cellSize
            }
            
            if model?.footerTitle != nil {
                headerFooterHeight += setting.cellSize
            }
            
            myHeightConstraint.constant = (setting.cellSize * CGFloat(numberOfCells)) + headerFooterHeight
        } else {
            myHeightConstraint.constant = tableView.contentSize.height
        }
    }
    
}

extension RKExpandableMenuView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard items[indexPath.row].isSelected == false else { return }
        if items[indexPath.row].isImageStable == true {
            // No need to update isSelected
        } else {
            for index in items.indices {
                items[index].isSelected = false
            }
            items[indexPath.row].isSelected = true
            tableView.reloadData()
        }
        items[indexPath.row].action()
        isHidden = setting.isDismissibleBySelection
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
                captionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: setting.horizontalInset),
                captionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -setting.horizontalInset)
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
        let expandableFooterMenuView = ExpandableFooterMenuView(setting: setting)
        expandableFooterMenuView.model = ExpandableFooterMenuModel(title: datasource.footerTitle, image: datasource.footerImage)
        expandableFooterMenuView.titleLabel.textColor = datasource.footerTitleColor
        expandableFooterMenuView.action = { [unowned self] in datasource.footerAction?() }
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
            return setting.cellSize
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if datasource.footerTitle == nil {
            return .zero
        } else {
            return setting.cellSize
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        setting.cellSize
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = BaseTableViewCell<ExpandableCellView>()
        cell.content.setting = setting
        cell.content.model = items[indexPath.row]
        cell.backgroundColor = customBackgroundColor
        cell.selectionStyle = .none
        return cell
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
    
    public struct ExpandableCellModel: ExpandableCell {
        public var id: String
        public var image: UIImage?
        public var title: String
        public var selectedImage: UIImage?
        public var unselectedImage: UIImage?
        public var isSelected: Bool
        public var isImageStable: Bool
        public var action: (() -> ())
        
        internal init(id: String = "", image: UIImage? = nil, title: String, selectedImage: UIImage? = nil, unselectedImage: UIImage? = nil, isSelected: Bool, isImageStable: Bool, action: @escaping (() -> ())) {
            self.id = id
            self.image = image
            self.title = title
            self.selectedImage = selectedImage
            self.unselectedImage = unselectedImage
            self.isSelected = isSelected
            self.isImageStable = isImageStable
            self.action = action
        }
    }
}
