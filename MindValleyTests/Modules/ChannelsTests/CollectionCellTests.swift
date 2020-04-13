//
//  CollectionCellTests.swift
//  MindValleyTests
//
//  Created by Canh Tran Wizeline on 4/13/20.
//  Copyright © 2020 CanhTran. All rights reserved.
//

import XCTest
@testable import MindValley

final class CollectionCellTests: MindValleyTests {
    
    private let courseItemWidth = (UIScreen.main.bounds.width - (4 * Constraints.paddingX2)) / 2
    private let seriesItemWidth = UIScreen.main.bounds.width - (3 * Constraints.paddingX2)
    
    func testCalculatingHeight() {
        MockChannelsInteractor().fetchChannels(loadFromCache: false) { (result) in
            switch result {
            case .success(let channels):
                channels.forEach { (channel) in
                    switch channel.type {
                    case .course:
                        if let firstMedia = channel.latestMedia.first {
                            let height = CourseCollectionCell.getHeightOfCourseCell(media: firstMedia,
                                                                                    width: self.courseItemWidth)
                            XCTAssertTrue(height > 100, "Height should not less than 100")
                            return
                        }
                        XCTFail("Can not get first media")
                    case .series:
                        if let firstSerie = channel.series.first {
                            let height = SeriesCollectionCell.getHeightOfSeriesCell(series: firstSerie,
                                                                                    width: self.seriesItemWidth)
                            XCTAssertTrue(height > 100, "Height should not less than 100")
                            return
                        }
                        XCTFail("Can not get first serie")
                    }
                    
                }
            case .failure:
                XCTFail("Can not get the data form listchannels.json")
            }
        }
        
    }
}
