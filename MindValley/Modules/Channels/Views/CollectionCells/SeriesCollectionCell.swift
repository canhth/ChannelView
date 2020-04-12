//
//  SeriesCollectionCell.swift
//  MindValley
//
//  Created by Canh Tran Wizeline on 4/12/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import UIKit
import Haneke

final class SeriesCollectionCell: CourseCollectionCell {
    
    private enum DesignConstraints {
        static let titleFont = MVFont.title
        static let seriesCoverMultiplier: CGFloat = 0.54
    }
    
    override func setupViews() {
        addSubview(coverImageView)
        coverImageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        coverImageView.heightAnchor.constraint(equalTo: coverImageView.widthAnchor,
                                               multiplier: DesignConstraints.seriesCoverMultiplier)
            .set(active: true)
        
        addSubview(mediaTitleStackView)
        mediaTitleStackView.anchor(top: coverImageView.bottomAnchor,
                                   left: coverImageView.leftAnchor,
                                   right: coverImageView.rightAnchor,
                                   paddingTop: Constraints.basePadding)
        mediaTitleStackView.bottomAnchor.constraint(equalTo: bottomAnchor).set(priority: UILayoutPriority.defaultLow).set(active: true)
    }
    
    func configCell(with series: Series) {
        
        if let iconURL = series.coverURL, let URL = URL(string: iconURL) {
            coverImageView.hnk_setImageFromURL(URL, format: Format<UIImage>.init(name: "original"))
        } else {
            coverImageView.image = UIImage(named: "default_icon")
        }
        mediaTitleLabel.text = series.title
        mediaSubTitleLabel.isHidden = true
    }
    
    static func getHeightOfSeriesCell(series: Series, width: CGFloat) -> CGFloat {
        // Image height
        var height = ceil(width * DesignConstraints.seriesCoverMultiplier)
        
        // Title height
        height += series.title.getEstimateFrame(width: width - Constraints.basePadding,
                                                height: 300,
                                                font: DesignConstraints.titleFont).height
        height += Constraints.basePadding
        
        return height - 1
    }
}
