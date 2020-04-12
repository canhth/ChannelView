// 
//  ChannelsViewController.swift
//  MindValley
//
//  Created by Canh Tran Wizeline on 4/9/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit

final class ChannelsViewController: BaseViewController {
    
    private enum DesignConstraints {
        static let courseItemWidth = (UIScreen.main.bounds.width - (4 * Constraints.paddingX2)) / 2
        static let seriesItemWidth = UIScreen.main.bounds.width - (3 * Constraints.paddingX2)
    }
    
    // MARK: - Public Properties

    var presenter: ChannelsPresenterInterface!
    
    // MARK: IBOutlets
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(ChannelSectionCell.self)
        tableView.register(CategorySectionCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = AppColor.darkBackground
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(handleRefresh(_:)),
                                 for: .valueChanged)

        return refreshControl
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .medium
        return indicator
    }()
    
    private var storedOffsets = [Int: CGFloat]()
    private lazy var maxHeightOfNewEpisodes: CGFloat = 0
    private lazy var maxHeightOfCategories: CGFloat = 1000
    private lazy var maxHeightOfChannels = [Int: CGFloat]()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.viewDidLoad()
    }

    // MARK: - Setup
    
    private func setupView() {
        statusBarStyle = .lightContent
        preferLargeTitleNavigationBar(enable: true, with: "Channels") 
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor,
                         left: view.safeAreaLayoutGuide.leftAnchor,
                         bottom: view.bottomAnchor,
                         right: view.safeAreaLayoutGuide.rightAnchor)
        
        view.addSubview(loadingIndicator)
        loadingIndicator.anchorCenter(horizontal: view.centerXAnchor,
                                      vertical: view.centerYAnchor)
        
        tableView.addSubview(refreshControl)
    }
    
    @objc
    private func handleRefresh(_ refreshControl: UIRefreshControl) {
        guard refreshControl.isRefreshing else { return }
        presenter.refreshAllChannels()
    }
    
    private func calculateHeightForSections() {
        // Calculating max height for New Episodes section
        maxHeightOfNewEpisodes = presenter.listNewEpisodes().compactMap {
            CourseCollectionCell.getHeightOfCourseCell(media: $0,
                                                       width: DesignConstraints.courseItemWidth)
        }.max() ?? 0
        
        // Calculating max height for Channel sections
        for i in 0..<presenter.listChannelItems().count {
            let channel = presenter.listChannelItems()[i]
            switch channel.type {
            case .course:
                maxHeightOfChannels[i] = channel.latestMedia.compactMap {
                    CourseCollectionCell.getHeightOfCourseCell(media: $0,
                                                               width: DesignConstraints.courseItemWidth)
                }.max() ?? 0
                
            case .series:
                maxHeightOfChannels[i] = channel.series.compactMap {
                    SeriesCollectionCell.getHeightOfSeriesCell(series: $0,
                                                               width: DesignConstraints.seriesItemWidth)
                }.max() ?? 0
            }
        }
        
        // Calculating max height for Categories section
        maxHeightOfCategories = CategorySectionCell.getTotalHeightWith(presenter.numberOfCategories())
    }
}

// MARK: - ChannelsViewInterface

extension ChannelsViewController: ChannelsViewInterface {
    func reloadData() {
        guard !refreshControl.isRefreshing else { return }
        
        DispatchQueue.runBackgroundTask({
            self.calculateHeightForSections()
        }, completion: {
            self.tableView.reloadData()
        })
    }
    
    func setLoadingVisible(_ visible: Bool) {
        loadingIndicator.isHidden = !visible
        if !visible {
            refreshControl.endRefreshing()
            loadingIndicator.stopAnimating()
        } else {
            loadingIndicator.startAnimating()
        }
    }
}

// MARK: - UITableViewDataSource

extension ChannelsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionType = ChannelSection.getSectionType(by: indexPath.row,
                                                        numberOfSections: presenter.numberOfSections())
        
        switch sectionType {
        case .newEpisodes:
            let cell: ChannelSectionCell = tableView.dequeueReusableCell(for: indexPath)
            cell.collectionViewHeight.constant = maxHeightOfNewEpisodes
            cell.configCell(with: nil, type: .newEpisodes)
            
            return cell
            
        case .channels:
            let cell: ChannelSectionCell = tableView.dequeueReusableCell(for: indexPath)
            cell.collectionViewHeight.constant = maxHeightOfChannels[indexPath.row - 1] ?? 0
            cell.configCell(with: presenter.channelAtIndex(index: indexPath.row - 1), type: .channels)
            
            return cell
            
        case .categories:
            let cell: CategorySectionCell = tableView.dequeueReusableCell(for: indexPath)
            cell.collectionViewHeight.constant = maxHeightOfCategories
            cell.configCell(with: nil, type: .categories)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension ChannelsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let tableViewCell = cell as? ChannelSectionCell {
            tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
            tableViewCell.setupCollectionViewDataSource(dataSource: self, index: indexPath.row)
        } else if let categoryCell = cell as? CategorySectionCell {
            categoryCell.setupCollectionViewDataSource(dataSource: self, index: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? ChannelSectionCell else { return }
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
}

// MARK: - UICollectionViewDataSource

extension ChannelsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = ChannelSection.getSectionType(by: collectionView.tag,
                                                        numberOfSections: presenter.numberOfSections())
        switch section {
        case .newEpisodes:
            return presenter.numberOfNewEpisodes()

        case .channels:
            let channel = presenter.channelAtIndex(index: collectionView.tag - 1)
            switch channel.type {
            case .course:
                return channel.latestMedia.count
            case .series:
                return channel.series.count
            }

        case .categories:
            return presenter.numberOfCategories()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = ChannelSection.getSectionType(by: collectionView.tag,
                                                        numberOfSections: presenter.numberOfSections())
        
        switch section {
            // New Episodes section
        case .newEpisodes:
            let cell: CourseCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configCell(with: presenter.newEpisodeAt(index: indexPath.row))
            
            return cell
            
            // Channel section
        case .channels:
            let channel = presenter.channelAtIndex(index: collectionView.tag - 1)
            switch channel.type {
            case .course:
                // Course layout
                let cell: CourseCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configCell(with: channel.latestMedia[indexPath.row])
                return cell
                
            case .series:
                // Series layout
                let cell: SeriesCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configCell(with: channel.series[indexPath.row])
                return cell
            }
            
            // Categories section
        case .categories:
            let cell: CategoryCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configCell(category: presenter.categoryAtIndex(index: indexPath.row))
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ChannelsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = ChannelSection.getSectionType(by: collectionView.tag,
                                                        numberOfSections: presenter.numberOfSections())
      
        var width = DesignConstraints.courseItemWidth

        switch section {
        case .newEpisodes:
            return CGSize(width: width,
                          height: maxHeightOfNewEpisodes)
            
        case .channels:
            let channel = presenter.channelAtIndex(index: collectionView.tag - 1)
            switch channel.type {
            case .course:  break
            case .series:
                width = DesignConstraints.seriesItemWidth
            }
            return CGSize(width: width,
                          height: maxHeightOfChannels[collectionView.tag - 1] ?? 0)
            
        case .categories:
            return CGSize(width: CategorySectionCell.DesignConstraints.categoryItemWidth,
                          height: CategorySectionCell.DesignConstraints.categoryItemHeight)
        }
    }
}
 
