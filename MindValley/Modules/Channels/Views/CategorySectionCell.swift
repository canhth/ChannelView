//
//  CategorySectionCell.swift
//  MindValley
//
//  Created by Canh Tran Wizeline on 4/10/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import UIKit

final class CategorySectionCell: UITableViewCell {
    
    enum DesignConstraints {
        static let categoryItemWidth = (UIScreen.main.bounds.width - (3 * Constraints.paddingX2)) / 2
        static let categoryItemHeight = ceil(categoryItemWidth * 60 / 160)
        static let categoryPadding: CGFloat = 16
    }
    
    // MARK: IBOutlets
    
    private let categoriesTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.lightHeader
        label.font = MVFont.section
        return label
    }()
    
    private let separateView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.separate
        return view
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = DesignConstraints.categoryPadding
        flowLayout.minimumInteritemSpacing = DesignConstraints.categoryPadding
        flowLayout.sectionInset = UIEdgeInsets(top: 0,
                                               left: Constraints.paddingX2,
                                               bottom: 0,
                                               right: Constraints.paddingX2)
         
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: flowLayout)
        collectionView.register(CategoryCollectionCell.self,
                                forCellWithReuseIdentifier: CategoryCollectionCell.typeName)
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
    
    private func setupViews() {
        backgroundColor = AppColor.darkBackground
        
        addSubview(separateView)
        separateView.anchor(top: topAnchor,
                            left: leftAnchor,
                            right: rightAnchor,
                            paddingLeft: Constraints.basePadding,
                            paddingRight: Constraints.basePadding,
                            height: Constraints.lineHeight)
        
        addSubview(categoriesTitleLabel)
        categoriesTitleLabel.anchor(top: separateView.bottomAnchor,
                                    left: leftAnchor,
                                    right: rightAnchor,
                                    paddingTop: Constraints.paddingX3,
                                    paddingLeft: Constraints.paddingX2,
                                    paddingRight: Constraints.paddingX2)
        
        addSubview(collectionView)
        collectionView.anchor(top: categoriesTitleLabel.bottomAnchor,
                              left: leftAnchor,
                              right: rightAnchor,
                              paddingTop: Constraints.paddingX2)
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constraints.paddingX3)
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
    
    func configCell() {
        categoriesTitleLabel.text = "Browse by categories"
        collectionView.reloadData()
    }
    
    static func getTotalHeightWith(_ numsOfCategory: Int) -> CGFloat {
        let numberOfCategoryRows = ceil(CGFloat(numsOfCategory) / 2)
        let totalRowsHeight = numberOfCategoryRows * CategorySectionCell.DesignConstraints.categoryItemHeight
        let paddingHeight = numberOfCategoryRows * (CategorySectionCell.DesignConstraints.categoryPadding - 1)
        
        return totalRowsHeight + paddingHeight
    }
}
