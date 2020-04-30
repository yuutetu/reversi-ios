//
//  BoardViewPresenter.swift
//  Reversi
//
//  Created by 加賀江 優幸 on 2020/04/30.
//  Copyright © 2020 Yuta Koshizawa. All rights reserved.
//

import Combine

struct Point {
    let x: Int
    let y: Int
}

public class BoardViewPresenter {
    /// 盤の幅（ `8` ）を表します。
    public static let width: Int = 8

    /// 盤の高さ（ `8` ）を返します。
    public static let height: Int = 8

    /// 盤のセルの `x` の範囲（ `0 ..< 8` ）を返します。
    public static let xRange: Range<Int> = 0 ..< width

    /// 盤のセルの `y` の範囲（ `0 ..< 8` ）を返します。
    public static let yRange: Range<Int> = 0 ..< height
    
    let handleDidSelectCell = PassthroughSubject<Point, Never>()
    var cellViewPresenters: [CellViewPresenter] = []

    func diskAt(x: Int, y: Int) -> Disk? {
        guard BoardViewPresenter.xRange.contains(x) && BoardViewPresenter.yRange.contains(y) else { return nil }
        return cellViewPresenters[y * BoardViewPresenter.width + x].diskSubject.value
    }
}
