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
    let handleDidSelectCell = PassthroughSubject<Point, Never>()
}
