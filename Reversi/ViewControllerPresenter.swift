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

enum Player: Int {
    case manual = 0
    case computer = 1

    var change: Player {
        switch self {
        case .manual:
            return .computer
        case .computer:
            return .manual
        }
    }
}

class ViewControllerPresenter {
    let darkCountSubject = CurrentValueSubject<Int, Never>(0)
    let lightCountSubject = CurrentValueSubject<Int, Never>(0)
    let turnSubject = CurrentValueSubject<Turn, Never>(.current(.dark))

    let playerControlValueChangedEvent = PassthroughSubject<Disk, Never>()
    let playerControlChangeRequest = PassthroughSubject<(Disk, Player), Never>()
    let darkPlayerControlSubject = CurrentValueSubject<Player, Never>(.manual)
    let lightPlayerControlSubject = CurrentValueSubject<Player, Never>(.manual)

    let darkActivityIndicatorSubject = CurrentValueSubject<Bool, Never>(false)
    let lightActivityIndicatorSubject = CurrentValueSubject<Bool, Never>(false)

    let boardViewPresenter: BoardViewPresenter

    // For UI
    let messageTextSubject = CurrentValueSubject<String, Never>("")
    let messageDiskSubject = CurrentValueSubject<Disk?, Never>(nil)

    private var cancellables: Set<AnyCancellable> = []

    init(boardViewPresenter: BoardViewPresenter) {
        self.boardViewPresenter = boardViewPresenter

        playerControlValueChangedEvent
            .filter({ disk in disk == .dark })
            .map({ _ in self.darkPlayerControlSubject.value.change })
            .subscribe(darkPlayerControlSubject)
            .store(in: &cancellables)
        playerControlChangeRequest
            .filter({ (disk, player) in disk == .dark })
            .map({ (disk, player) in player })
            .subscribe(darkPlayerControlSubject)
            .store(in: &cancellables)
        playerControlValueChangedEvent
            .filter({ disk in disk == .light })
            .map({ _ in self.lightPlayerControlSubject.value.change })
            .subscribe(lightPlayerControlSubject)
            .store(in: &cancellables)
        playerControlChangeRequest
            .filter({ (disk, player) in disk == .light })
            .map({ (disk, player) in player })
            .subscribe(lightPlayerControlSubject)
            .store(in: &cancellables)

        // turnSubject -> messageTextSubject
        turnSubject.map { turn -> String in
            switch turn {
            case .current:
                return "'s turn"
            case .finished:
                // TODO: 勝者判定。一箇所にまとめたい。
                let darkCount = self.countDisks(of: .dark)
                let lightCount = self.countDisks(of: .light)
                if darkCount == lightCount {
                    return "Tied"
                } else {
                    return " won"
                }
            }
        }.subscribe(messageTextSubject).store(in: &cancellables)

        // turnSubject -> messageDiskSubject
        turnSubject.map { turn -> Disk? in
            switch turn {
            case .current(let disk):
                return disk
            case .finished:
                // TODO: 勝者判定。一箇所にまとめたい。
                let darkCount = self.countDisks(of: .dark)
                let lightCount = self.countDisks(of: .light)
                if darkCount == lightCount {
                    return nil
                } else {
                    return darkCount > lightCount ? .dark : .light
                }
            }
        }.subscribe(messageDiskSubject).store(in: &cancellables)

        // For Debug
        darkPlayerControlSubject.sink { player in
            print("[Debug] disk: dark, player: " + String(player.rawValue))
        }.store(in: &cancellables)
        lightPlayerControlSubject.sink { player in
            print("[Debug] disk: light, player: " + String(player.rawValue))
        }.store(in: &cancellables)
    }

    func playerControlSubject(forDisk disk: Disk) -> CurrentValueSubject<Player, Never> {
        switch disk {
        case .dark:
            return darkPlayerControlSubject
        case .light:
            return lightPlayerControlSubject
        }
    }

    func activityIndicatorSubject(forDisk disk: Disk) -> CurrentValueSubject<Bool, Never> {
        switch disk {
        case .dark:
            return darkActivityIndicatorSubject
        case .light:
            return lightActivityIndicatorSubject
        }
    }

    func countDisks(of side: Disk) -> Int {
        var count = 0

        for y in BoardViewPresenter.yRange {
            for x in BoardViewPresenter.xRange {
                if boardViewPresenter.diskAt(x: x, y: y) == side {
                    count +=  1
                }
            }
        }

        return count
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

    func unsafeSetTurn(disk: Disk?) {
        switch disk {
        case .some(let disk):
            turnSubject.send(.current(disk))
        case .none:
            turnSubject.send(.finished)
        }
    }
}
