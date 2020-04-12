//
//  ChannelSectionCell.swift
//  MindValley
//
//  Created by Canh Tran Wizeline on 4/10/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import UIKit
import Haneke

class ChannelSectionCell: UITableViewCell {
    
    private enum DesignConstraints {
        static let titlePadding: CGFloat = 14
        static let collectionPadding: CGFloat = 16
        static let logoImageSize = CGSize(width: 50, height: 50)
    }
    
    var collectionViewOffset: CGFloat {
        get { return collectionView.contentOffset.x }
        set { collectionView.contentOffset.x = newValue }
    }
    
    private var channelTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.lightHeader
        label.font = MVFont.section
        return label
    }()
    
    private var mediaNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.lightMedium
        label.font = MVFont.subTitle
        return label
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.anchor(width: DesignConstraints.logoImageSize.width.dp,
                         height: DesignConstraints.logoImageSize.height.dp)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = DesignConstraints.logoImageSize.width.dp / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var channelTitleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [channelTitleLabel,
                                                       mediaNumberLabel])
        stackView.axis = .vertical
        channelTitleLabel.setContentHuggingPriority(.required, for: .vertical)
        mediaNumberLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return stackView
    }()
    
    private lazy var channelSectionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [logoImageView,
                                                       channelTitleStackView])
        stackView.spacing = DesignConstraints.titlePadding
        stackView.axis = .horizontal
        return stackView
    }()
    
    private var separateView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.separate
        return view
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 20
        flowLayout.headerReferenceSize = .zero
        flowLayout.footerReferenceSize = .zero
        flowLayout.sectionInset = UIEdgeInsets(top: 0,
                                               left: Constraints.basePadding,
                                               bottom: 0,
                                               right: Constraints.basePadding)
        flowLayout.estimatedItemSize = .zero
         
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: flowLayout)
        collectionView.register(MediaCollectionCell.self,
                                forCellWithReuseIdentifier: MediaCollectionCell.typeName)
        collectionView.register(CategoryCollectionCell.self,
                                forCellWithReuseIdentifier: CategoryCollectionCell.typeName)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = false 
        collectionView.contentInset = UIEdgeInsets(top: 0,
                                                   left: Constraints.basePadding,
                                                   bottom: 0,
                                                   right: Constraints.basePadding)

        collectionView.backgroundColor = AppColor.darkBackground
        return collectionView
    }()
    
    lazy var collectionViewHeight = NSLayoutConstraint()
    
    // MARK: - Public functions
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        channelTitleLabel.text = ""
        logoImageView.hnk_cancelSetImage()
        logoImageView.image = nil
    }
    
    private func setupViews() {
        backgroundColor = AppColor.darkBackground
        
        addSubview(separateView)
        separateView.anchor(top: topAnchor,
                            left: leftAnchor,
                            right: rightAnchor,
                            paddingLeft: Constraints.basePadding,
                            paddingRight: Constraints.basePadding,
                            height: Constraints.lineHeight)
        
        addSubview(channelSectionStackView)
        channelSectionStackView.anchor(top: separateView.bottomAnchor,
                                       left: leftAnchor,
                                       right: rightAnchor,
                                       paddingTop: Constraints.paddingX2,
                                       paddingLeft: Constraints.paddingX2,
                                       paddingRight: Constraints.paddingX2)
        
        addSubview(collectionView)
        collectionView.anchor(top: channelSectionStackView.bottomAnchor,
                              left: leftAnchor,
                              right: rightAnchor,
                              paddingTop: DesignConstraints.collectionPadding)
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constraints.paddingX3)
            .set(priority: .defaultLow)
            .set(active: true)
        collectionViewHeight = collectionView.heightAnchor.constraint(equalToConstant: 150)
            .set(active: true)
    }
    
    func setupCollectionViewDataSource(dataSource: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout,
                                       index: Int) {
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
        collectionView.tag = index
    }
    
    func configCell(with channel: Channel?, type: ChannelSection) {
        switch type {
        case .categories, .newEpisodes:
            separateView.isHidden = type == .newEpisodes
            logoImageView.isHidden = true
            mediaNumberLabel.isHidden = true
            channelTitleLabel.textColor = AppColor.lightHeader
            channelTitleLabel.font = MVFont.section
            channelTitleLabel.text = (type == .newEpisodes) ? "New Episodes" : "Browse by categories"
            
        case .channels:
            logoImageView.isHidden = false
            mediaNumberLabel.isHidden = false
            channelTitleLabel.text = channel?.title
            channelTitleLabel.textColor = AppColor.white
            channelTitleLabel.font = MVFont.channelSection
            mediaNumberLabel.text = "\(channel?.mediaCount ?? 0) episodes"
            if let iconURL = channel?.iconURL, let URL = URL(string: iconURL) {
                logoImageView.hnk_setImageFromURL(URL, format: Format<UIImage>.init(name: "original"))
            } else {
                logoImageView.isHidden = true
            }
        }
        collectionView.reloadData()
    }
}
