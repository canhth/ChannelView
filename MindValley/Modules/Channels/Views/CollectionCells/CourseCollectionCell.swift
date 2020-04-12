//
//  CourseCollectionCell.swift
//  MindValley
//
//  Created by Canh Tran Wizeline on 4/10/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import UIKit
import Haneke

class CourseCollectionCell: UICollectionViewCell {
    
    private enum DesignConstraints {
        static let titlePadding: CGFloat = 14
        static let titleFont = MVFont.title
        static let subTitleFont = MVFont.subTitle
        static let courseCoverMultiplier: CGFloat = 1.5
    }
    
    // MARK: IBOutlets
    
    let mediaTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.white
        label.font = DesignConstraints.titleFont
        label.numberOfLines = 0
        return label
    }()
    
    let mediaSubTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.lightMedium
        label.font = DesignConstraints.subTitleFont
        label.numberOfLines = 0
        return label
    }()
    
    let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constraints.basePadding
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var mediaTitleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mediaTitleLabel,
                                                       mediaSubTitleLabel])
        stackView.spacing = Constraints.basePadding
        stackView.axis = .vertical
        mediaTitleLabel.setContentHuggingPriority(.required, for: .vertical)
        mediaSubTitleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return stackView
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.hnk_cancelSetImage()
        coverImageView.image = nil
    }
    
    // MARK: Setups
    
    func setupViews() {
        addSubview(coverImageView)
        coverImageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor) 
        coverImageView.heightAnchor.constraint(equalTo: coverImageView.widthAnchor,
                                               multiplier: DesignConstraints.courseCoverMultiplier)
            .set(active: true)
        
        addSubview(mediaTitleStackView)
        mediaTitleStackView.anchor(top: coverImageView.bottomAnchor,
                                   left: coverImageView.leftAnchor,
                                   right: coverImageView.rightAnchor,
                                   paddingTop: Constraints.basePadding,
                                   paddingLeft: Constraints.basePadding / 2,
                                   paddingRight: Constraints.basePadding / 2)
        mediaTitleStackView.bottomAnchor.constraint(equalTo: bottomAnchor).set(priority: UILayoutPriority.defaultLow).set(active: true)
    }
    
    func configCell(with media: Media) {
        
        if let iconURL = media.coverURL, let URL = URL(string: iconURL) {
            coverImageView.hnk_setImageFromURL(URL, format: Format<UIImage>.init(name: "original"))
        } else {
            coverImageView.image = UIImage(named: "default_icon")
        }
        mediaTitleLabel.text = media.title
        mediaSubTitleLabel.text = media.channelName.uppercased()
        mediaSubTitleLabel.isHidden = media.channelName.isEmpty
    }
    
    static func getHeightOfCourseCell(media: Media, width: CGFloat) -> CGFloat {
        // Image height
        var height = width * DesignConstraints.courseCoverMultiplier
        
        // Title height
        height += media.title.getEstimateFrame(width: width - Constraints.basePadding,
                                               height: 500,
                                               font: DesignConstraints.titleFont).height
        height += Constraints.basePadding
        
        // Sub title height
        if !media.channelName.isEmpty {
            height += media.channelName.getEstimateFrame(width: width - Constraints.basePadding,
                                                         height: 500,
                                                         font: DesignConstraints.subTitleFont).height
            height += Constraints.basePadding
        }
        
        return height
    }
}
