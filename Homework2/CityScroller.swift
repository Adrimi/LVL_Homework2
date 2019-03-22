//
//  CityScroller.swift
//  Homework2
//
//  Created by Adrimi on 20/03/2019.
//  Copyright © 2019 Adrimi. All rights reserved.
//

import UIKit

class CityScroller: UIScrollView {

    private let buildingContainerView = UIView()
    private var visibleBuildings: [BuildingView] = []
    private var recycledViews: Set<BuildingView> = Set<BuildingView>()
    
    init() {
        super.init(frame: .zero)
        addSubview(buildingContainerView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup(size: CGSize) {
        contentSize = CGSize(width: size.width * 5, height: size.height * 1.2)
        buildingContainerView.frame = CGRect(origin: .zero, size: contentSize)
        backgroundColor = .blue
        indicatorStyle = .white
        
        recycledViews.formUnion(visibleBuildings)
        visibleBuildings.forEach { $0.removeFromSuperview() }
        visibleBuildings.removeAll()
        contentOffset.x = (contentSize.width - bounds.width) / 2.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let visibleBounds = convert(bounds, to: buildingContainerView)
        tileBuildings(from: visibleBounds.minX, to: visibleBounds.maxX)
        makeInfinity()
    }
    
    public func makeInfinity() {
        if contentOffset.x > contentSize.width - 402 || contentOffset.x < 402 {
            visibleBuildings.forEach {
                $0.frame.origin.x = contentSize.width / 2.0
                print("\($0.frame.origin.x)")
            }
        }
    }
    
    private func tileBuildings(from minX: CGFloat, to maxX: CGFloat) {
        if visibleBuildings.count == 0 { _ = placeNewBuildingOnTheRight(edge: 0.0) }
        
        var lastBuilding = visibleBuildings.last!
        while lastBuilding.frame.maxX < maxX {
            lastBuilding = placeNewBuildingOnTheRight(
                edge: lastBuilding.frame.maxX)
        }

        var firstBuilding = visibleBuildings.first!
        while firstBuilding.frame.minX > minX {
            firstBuilding = placeNewBuildingOnTheLeft(
                edge: firstBuilding.frame.minX)
        }

        var indicesToRemove: [Int] = []
        for (index, building) in visibleBuildings.enumerated() {
            if building.frame.maxX <= minX || building.frame.minX >= maxX {
                indicesToRemove.append(index)
                building.removeFromSuperview()
                recycledViews.insert(building)
            }
        }

        for index in indicesToRemove.reversed() {
            visibleBuildings.remove(at: index)
        }
    }
    
    private func placeNewBuildingOnTheRight(edge: CGFloat) -> BuildingView {
        let building = BuildingView.randomBuilding()
        building.frame.origin.x = edge
        building.frame.origin.y = contentSize.height - building.frame.maxY
        visibleBuildings.append(building)
        buildingContainerView.addSubview(building)
        return building
    }
    
    private func placeNewBuildingOnTheLeft(edge: CGFloat) -> BuildingView {
        let building = BuildingView.randomBuilding()
        building.frame.origin.x = edge - building.frame.width
        building.frame.origin.y = contentSize.height - building.frame.maxY
        visibleBuildings.insert(building, at: 0)
        buildingContainerView.addSubview(building)
        return building
    }
    
    override var frame: CGRect {
        didSet {
            setup(size: bounds.size)
        }
    }

}
