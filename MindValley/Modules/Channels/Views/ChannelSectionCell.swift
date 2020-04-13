//
//  ChannelSectionCell.swift
//  MindValley
//
//  Created by Canh Tran Wizeline on 4/10/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import UIKit
import Haneke

final class ChannelSectionCell: UITableViewCell {
    
    private enum DesignConstraints {
        static let titlePadding: CGFloat = 14
        static let collectionPadding: CGFloat = 16
        static let logoImageSize = CGSize(width: 50, height: 50)
    }
    // MARK: IBOutlets
    
    var collectionViewOffset: CGFloat {
        get { return collectionView.contentOffset.x }
        set { collectionView.contentOffset.x = newValue }
    }
    
    private let channelTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.lightHeader
        label.font = MVFont.section
        label.numberOfLines = 0
        return label
    }()
    
    private let mediaNumberLabel: UILabel = {
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
        imageView.backgroundColor = AppColor.lightMedium.withAlphaComponent(0.6)
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
    
    private let separateView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.separate
        return view
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = Constraints.paddingX2
        flowLayout.headerReferenceSize = .zero
        flowLayout.footerReferenceSize = .zero
        flowLayout.sectionInset = UIEdgeInsets(top: 0,
                                               left: Constraints.paddingX2,
                                               bottom: 0,
                                               right: Constraints.paddingX2)
         
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: flowLayout)
        collectionView.register(CourseCollectionCell.self,
                                forCellWithReuseIdentifier: CourseCollectionCell.typeName)
        collectionView.register(SeriesCollectionCell.self,
                                forCellWithReuseIdentifier: SeriesCollectionCell.typeName)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = false
        collectionView.backgroundColor = AppColor.darkBackground
        
        return collectionView
    }()
    
    lazy var collectionViewHeight = NSLayoutConstraint()
    
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        channelTitleLabel.text = ""
        logoImageView.hnk_cancelSetImage()
        logoImageView.image = nil
    }
    
    private func setupViews() {
        backgroundColor = AppColor.darkBackground
        
        contentView.addSubview(separateView)
        separateView.anchor(top: contentView.topAnchor,
                            left: contentView.leftAnchor,
                            right: contentView.rightAnchor,
                            paddingLeft: Constraints.basePadding,
                            paddingRight: Constraints.basePadding,
                            height: Constraints.lineHeight)
        
        contentView.addSubview(channelSectionStackView)
        channelSectionStackView.anchor(top: separateView.bottomAnchor,
                                       left: contentView.leftAnchor,
                                       right: contentView.rightAnchor,
                                       paddingTop: Constraints.paddingX2,
                                       paddingLeft: Constraints.paddingX2,
                                       paddingRight: Constraints.paddingX2)
        
        contentView.addSubview(collectionView)
        collectionView.anchor(top: channelSectionStackView.bottomAnchor,
                              left: contentView.leftAnchor,
                              right: contentView.rightAnchor,
                              paddingTop: DesignConstraints.collectionPadding)
        collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constraints.paddingX3)
            .set(priority: .defaultLow)
            .set(active: true)
        collectionViewHeight = collectionView.heightAnchor.constraint(equalToConstant: 150)
            .set(active: true)
    }
    
    // MARK: - Public functions
    
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
            separateView.isHidden = false
            channelTitleLabel.text = channel?.title
            channelTitleLabel.textColor = AppColor.white
            channelTitleLabel.font = MVFont.channelSection
            
            if let iconURL = channel?.iconURL, let URL = URL(string: iconURL) {
                logoImageView.hnk_setImageFromURL(URL, format: Format<UIImage>.init(name: "original"))
            } else {
                logoImageView.image = UIImage(named: "default_icon")
            }
            
            switch channel?.type {
            case .course:
                mediaNumberLabel.text = (channel?.mediaCount ?? 0).toStringWithPattern("episode")
            case .series:
                mediaNumberLabel.text = (channel?.series.count ?? 0).toStringWithPattern("serie")
            case .none:
                break
            }
        }
        collectionView.reloadData()
    }
}
