//
//  ViewControllerPresenter.swift
//  Reversi
//
//  Created by 加賀江 優幸 on 2020/04/27.
//  Copyright © 2020 Yuta Koshizawa. All rights reserved.
//

import Combine

// どちらの色のプレイヤーのターンかを表します。
enum Turn {
    case current(Disk)
    case finished
}

class ViewControllerPresenter {
    let darkCountSubject = CurrentValueSubject<Int, Never>(0)
    let lightCountSubject = CurrentValueSubject<Int, Never>(0)
    let turnSubject = CurrentValueSubject<Turn, Never>(.current(.dark))

    let playerControlValueChangedEvent = PassthroughSubject<Disk, Never>()
    let playerControlChangeRequest = PassthroughSubject<Disk, Never>()
    let playerControlSubject = CurrentValueSubject<Disk, Never>(.dark)

    private var cancellables: Set<AnyCancellable> = []

    init() {
        playerControlValueChangedEvent
            .subscribe(playerControlSubject)
            .store(in: &cancellables)
        playerControlChangeRequest
            .subscribe(playerControlSubject)
            .store(in: &cancellables)

        // For Debug
        playerControlSubject.sink { disk in
            print(disk)
        }.store(in: &cancellables)
    }

    // 互換性担保
    var unsafeTurn: Disk? {
        switch turnSubject.value {
        case .current(let disk):
            return disk
        case .finished:
            return nil
        }
    }

    func unsafeSetDisk(disk: Disk?) {
        switch disk {
        case .some(let disk):
            turnSubject.send(.current(disk))
        case .none:
            turnSubject.send(.finished)
        }
    }
}
