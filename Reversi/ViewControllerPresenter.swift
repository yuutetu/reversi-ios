//
//  ViewControllerPresenter.swift
//  Reversi
//
//  Created by 加賀江 優幸 on 2020/04/27.
//  Copyright © 2020 Yuta Koshizawa. All rights reserved.
//

import Combine

class ViewControllerPresenter {
    let darkCountSubject = CurrentValueSubject<Int, Never>(0)
    let lightCountSubject = CurrentValueSubject<Int, Never>(0)
}
