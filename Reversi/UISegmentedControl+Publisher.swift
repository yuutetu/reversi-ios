//
//  UISegmentedControl+Publisher.swift
//  Reversi
//
//  Created by 加賀江 優幸 on 2020/04/28.
//  Copyright © 2020 Yuta Koshizawa. All rights reserved.
//

import UIKit
import Combine

extension UIControl {
    final class Subscription<SubscriberType: Subscriber, Control: UIControl>: Combine.Subscription where SubscriberType.Input == Control {
        private var subscriber: SubscriberType?
        private let control: Control

        init(subscriber: SubscriberType, control: Control, event: UIControl.Event) {
            self.subscriber = subscriber
            self.control = control
            control.addTarget(self, action: #selector(eventHandler), for: event)
        }

        func request(_ demand: Subscribers.Demand) {
        }

        func cancel() {
            subscriber = nil
        }

        @objc private func eventHandler() {
            _ = subscriber?.receive(control)
        }

        deinit {
            print("UIControlTarget deinit")
        }
    }

   struct Publisher<Control: UIControl>: Combine.Publisher {
        typealias Output = Control
        typealias Failure = Never

        let control: Control
        let controlEvents: UIControl.Event

        init(control: Control, events: UIControl.Event) {
            self.control = control
            self.controlEvents = events
        }

        func receive<S>(subscriber: S) where S : Subscriber, S.Failure == Failure, S.Input == Output {
            let subscription = UIControl.Subscription(subscriber: subscriber, control: control, event: controlEvents)
            subscriber.receive(subscription: subscription)
        }
    }
}

protocol CombineCompatible { }
extension UIControl: CombineCompatible { }
extension CombineCompatible where Self: UIControl {
    func publisher(for events: UIControl.Event) -> UIControl.Publisher<Self> {
        return UIControl.Publisher(control: self, events: events)
    }
}
