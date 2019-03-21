//
//  AsyncPollingTask.swift
//  CurrencyConverter
//
//  Created by Koushal, KumarAjitesh on 2019/03/16.
//  Copyright © 2019 Koushal, KumarAjitesh. All rights reserved.
//

import Foundation
import Promise

let concurrentPollingQueue = DispatchQueue(label: "polling_queue", attributes: .concurrent)

// Requests on demand (as Promises)
struct RequestFactory<T: Codable> {
    var getRequest: (() -> Promise<T>)!
}

class AsyncPollingTask<T: Codable> {
    let requestFactory: RequestFactory<T>!
    let completion: ((T) -> Void)!
    // Polling interval
    let interval: TimeInterval!
    // Polling timer (in seconds) that will run in concurrent queue
    let timer = DispatchSource.makeTimerSource(queue: concurrentPollingQueue)
    
    init(requestFactory: RequestFactory<T>, completion: @escaping ((T) -> Void), interval: TimeInterval) {
        self.requestFactory = requestFactory
        self.completion = completion
        self.interval = interval
    }
    
    deinit {
        timer.setEventHandler {}
        timer.cancel()
    }
    
    // Setup and starts the polling timer and its handler
    func start() {
        timer.schedule(deadline: .now(), repeating: .milliseconds(Int(interval * 1000)), leeway: .milliseconds(100))
        
        timer.setEventHandler { [weak self] in
            guard let self = self else { return}
            self.requestFactory.getRequest().then({ [weak self] response in
                guard let self = self else { return}
                self.completion(response)
            })
        }
        
        timer.resume()
    }
}
