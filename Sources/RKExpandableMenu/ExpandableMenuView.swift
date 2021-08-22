
//
//  ExpandableNavigationBarItemView.swift
//  Magnet
//
//  Created by Reza Khonsari on 7/3/20.
//

import UIKit

public class ExpandableMenuView: UIView {
    static let identifier = "ExpandableCell"
    
    private lazy var myHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: .zero)
    
    public var customBackgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 0.5005648784) {
        didSet {
            tableView.reloadData()
        }
    }
    
    public var textAlignment: NSTextAlignment = .left { didSet { tableView.reloadData() } }
    
    public var font: UIFont = .systemFont(ofSize: 14) { didSet { tableView.reloadData() } }
    
    public var radius: CGFloat = 4 { didSet { mainView.layer.cornerRadius = radius; layoutIfNeeded() } }
    
    public var headerFont: UIFont = .boldSystemFont(ofSize: 16) { didSet { tableView.reloadData() } }
    
    public var model: ExpandableMenuItems? { didSet { setModel(model) } }
    
    private func setModel(_ model: ExpandableMenuItems?) {
        tableView.reloadData()
        layoutIfNeeded()
    }
    
    var mainView = UIView()
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
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
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = Style.Spacing.cornerRadius
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 3
        layer.shadowOffset = .zero
        layer.cornerRadius = radius
        
        myHeightConstraint.constant = tableView.contentSize.height
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

extension ExpandableMenuView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = model else { fatalError("Must have model") }
        guard model.items[indexPath.row].isSelected == false else { return }
        for index in model.items.indices {
            self.model?.items[index].isSelected = false
        }
        self.model?.items[indexPath.row].isSelected = true
        tableView.reloadData()
        model.items[indexPath.row].action?()
        isHidden = true
    }
}

extension ExpandableMenuView: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerTitle = model?.headerTitle {
            let view = UIView()
            let captionLabel = UILabel()
            view.addSubview(captionLabel)
            captionLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                captionLabel.topAnchor.constraint(equalTo: view.topAnchor),
                captionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                captionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                captionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            ])
            captionLabel.text = headerTitle
            captionLabel.textColor = .black
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
        expandableFooterMenuView.model = ExpandableFooterMenuModel(title: model?.footerTitle, image: model?.footerImage)
        return expandableFooterMenuView
    }
    
    @objc private func headerDidTouch() {
        model?.headerAction?()
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if model?.headerTitle == nil {
            return .zero
        } else {
            return 44
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if model?.footerTitle == nil {
            return .zero
        } else {
            return 44
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model?.items.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BaseTableViewCell<ExpandableCellView>()

//        cell.content.captionLabel.textColor = model?.items[indexPath.row].isSelected == true ? Theme.color.accent : .black
//        cell.content.tickImageView.isHidden = model?.items[indexPath.row].isSelected == false
        cell.content.tickImageView.isHidden = true
        cell.backgroundColor = customBackgroundColor
        cell.content.captionLabel.font = font
        cell.content.captionLabel.text = model?.items[indexPath.row].title
        cell.content.captionLabel.textAlignment = textAlignment
        cell.selectionStyle = .none
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        for view in cell.subviews {
            view.removeFromSuperview()
        }
    }
    
}

extension ExpandableMenuView {
    struct ExpandableFooterMenuModel: ExpandableFooterMenu {
        var title: String?
        var image: String?
    }
}
