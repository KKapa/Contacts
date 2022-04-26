//
//  ValueChangeNotifier.swift
//  AppContacts
//
//  Created by Павел Струков on 28.03.22.
//

import Foundation

final class ValueChangeNotifier<V> {
    typealias ObserverBlock = (V) -> Void
    
    private var observerBlock: ObserverBlock?
    
    var value: V {
        didSet {
            observerBlock?(value)
        }
    }
    
    init(value: V) {
        self.value = value
    }
    
    func bindObserver(with block: @escaping ObserverBlock) {
        self.observerBlock = block
        block(value)
    }
}
