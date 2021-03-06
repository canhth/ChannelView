//
//  CategoryCollectionCell.swift
//  MindValley
//
//  Created by Canh Tran Wizeline on 4/10/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import UIKit

final class CategoryCollectionCell: UICollectionViewCell {
    
    private let categoryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = MVFont.category
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.contentHorizontalAlignment = .center
        button.titleEdgeInsets = UIEdgeInsets(top: 0,
                                              left: Constraints.basePadding,
                                              bottom: 0,
                                              right: Constraints.basePadding)
        button.backgroundColor = AppColor.lightMedium.withAlphaComponent(0.2)
        button.layer.cornerRadius = CGFloat(30).dp
        button.isUserInteractionEnabled = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(categoryButton)
        categoryButton.pinToSuperview()
    }
    
    func configCell(category: Category?) {
        guard let category = category else { return }
        categoryButton.setTitle(category.name, for: .normal)
    }
}
