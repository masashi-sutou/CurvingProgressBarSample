//
//  ProgressTimer.swift
//  CurvingProgressBarSample
//
//  Created by Keisuke Shoji on 2017/09/12.
//  Copyright © 2017年 Keisuke Shoji. All rights reserved.
//

import QuartzCore

final class ProgressTimer {

    private var displayLink: CADisplayLink!
    private var startTimeInterval: TimeInterval = 0.0
    private let duration: TimeInterval
    private let unitBezier: UnitBezier
    var progressBlock: ((CGFloat) -> Void)?

    init(duration: TimeInterval = 1.0, animationCurve: AnimationCurve) {
        self.duration = duration
        unitBezier = UnitBezier(p1: animationCurve.p1, p2: animationCurve.p2)

        displayLink = CADisplayLink(target: self, selector: #selector(updateTimer))
        displayLink.preferredFramesPerSecond = 60
        displayLink.isPaused = true
        displayLink.add(to: .current, forMode: .commonModes)
    }

    func startTimer() {
        startTimeInterval = Date.timeIntervalSinceReferenceDate
        displayLink.isPaused = false
    }

    @objc private func updateTimer() {
        let elapsed: TimeInterval = Date.timeIntervalSinceReferenceDate - startTimeInterval
        let progress: CGFloat = (elapsed > duration) ? 1.0 : CGFloat(elapsed / duration)

        // cubic bezier
        let y: CGFloat = unitBezier.solve(t: progress)
        progressBlock?(y)

        if progress == 1.0 {
            displayLink.isPaused = true
        }
    }
}
