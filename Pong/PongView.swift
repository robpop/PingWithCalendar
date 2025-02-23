//
//  PongView.swift
//  Pong
//
//  Created by Jared Macias on 10/4/19.
//  Copyright © 2019 Jared Macias. All rights reserved.
//
import Foundation
import ScreenSaver

class PongView: ScreenSaverView {

    private var ballPosition: CGPoint = .zero
    private var ballVelocity: CGVector = .zero
    private var paddlePosition: CGFloat = 0
    private let ballRadius: CGFloat = 70
    private let paddleBottomOffset: CGFloat = 50
    private let paddleSize = NSSize(width: 200, height: 40)
    private var timeLabel = View(xpos:0, ypos: 0, bwidth: 0, bheight: 0)
    private let timeOffsetY: CGFloat =  16;
    private let timeOffsetX: CGFloat =  22;
    

    // MARK: - Initialization
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        ballPosition = CGPoint(x: frame.width / 2, y: frame.height / 2)
        ballVelocity = initialVelocity()
        displayTime()
    }

    @available(*, unavailable)
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func draw(_ rect: NSRect) {
        drawBackground(.black)
        drawBall()
        drawTime()
        drawPaddle()
        clock()
    }

    override func animateOneFrame() {
        super.animateOneFrame()

        let oobAxes = ballIsOOB()
        if oobAxes.xAxis {
            ballVelocity.dx *= -1
        }
        if oobAxes.yAxis {
            ballVelocity.dy *= -1
        }

        let paddleContact = ballHitPaddle()
        if paddleContact {
            ballVelocity.dy *= -1
        }

        ballPosition.x += ballVelocity.dx
        ballPosition.y += ballVelocity.dy
        paddlePosition = ballPosition.x

        setNeedsDisplay(bounds)
    }

    // MARK: - Helper Functions
    private func drawBackground(_ color: NSColor) {
        let background = NSBezierPath(rect: bounds)
        color.setFill()
        background.fill()
    }

    private func drawBall() {
        
        let ballRect = NSRect(x: ballPosition.x - ballRadius,
                              y: ballPosition.y - ballRadius,
                              width: ballRadius * 2,
                              height: ballRadius * 2)
        let ball = NSBezierPath(roundedRect: ballRect,
                                xRadius: ballRadius,
                                yRadius: ballRadius)
        NSColor.white.setFill()
        ball.fill()
    }

    private func drawPaddle() {
        let paddleRect = NSRect(x: paddlePosition - paddleSize.width / 2,
                                y: paddleBottomOffset - paddleSize.height / 2,
                                width: paddleSize.width,
                                height: paddleSize.height)
        let paddle = NSBezierPath(rect: paddleRect)
        NSColor.white.setFill()
        paddle.fill()
    }

    private func initialVelocity() -> CGVector {
        let desiredVelocityMagnitude: CGFloat = 6
        let xVelocity = CGFloat.random(in: 3...5)
        let xSign: CGFloat = Bool.random() ? 1 : -1
        let yVelocity = sqrt(pow(desiredVelocityMagnitude, 2) - pow(xVelocity, 2))
        let ySign: CGFloat = Bool.random() ? 1 : -1
        return CGVector(dx: xVelocity * xSign, dy: yVelocity * ySign)
    }

    private func ballIsOOB() -> (xAxis: Bool, yAxis: Bool) {
        let xAxisOOB = ballPosition.x - ballRadius <= 0 ||
            ballPosition.x + ballRadius >= bounds.width
        let yAxisOOB = ballPosition.y - ballRadius <= 0 ||
            ballPosition.y + ballRadius >= bounds.height
        return (xAxisOOB, yAxisOOB)
    }

    private func ballHitPaddle() -> Bool {
        let xBounds = (lower: paddlePosition - paddleSize.width / 2,
                       upper: paddlePosition + paddleSize.width / 2)
        let yBounds = (lower: paddleBottomOffset - paddleSize.height / 2,
                       upper: paddleBottomOffset + paddleSize.height / 2)
        return ballPosition.x >= xBounds.lower &&
            ballPosition.x <= xBounds.upper &&
            ballPosition.y - ballRadius >= yBounds.lower &&
            ballPosition.y - ballRadius <= yBounds.upper
    }
    
    // MARK: - Clock Functions
    private func displayTime() {
        timeLabel.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(timeLabel)
    }
    
    private func drawTime() {
        timeLabel.detailLabel.stringValue = timeLabel.updateTime()
        timeLabel.frame = NSRect(x: (ballPosition.x - ballRadius/2) - timeOffsetX,
        y: (ballPosition.y - ballRadius/2) + timeOffsetY,
        width: ballRadius*2, height: ballRadius*2)
    }
    
}
