//
//  Movie.swift
//  Movie
//
//  Created by Ben on 2019/08/01.
//  Copyright © 2019 Ben. All rights reserved.
//

import Foundation

public class Screening {
    
    private let movie: Movie
    private let sequence: Int
    private let whenScreened: Date
    
    public var startTime: Date {
        return whenScreened
    }
    
    public var movieFee: Money {
        return movie.getFee()
    }
    
    public init(movie: Movie, sequence: Int, whenScreened: Date) {
        self.movie = movie
        self.sequence = sequence
        self.whenScreened = whenScreened
    }
    
    public func isSequence(_ sequence: Int) -> Bool {
        return self.sequence == sequence
    }
    
    public func reserve(customer: Customer, numberOfAudience: Int) -> Reservation {
        return Reservation(customer: customer, screening: self, fee: calculate(numberOfAudience), numberOfAudience: numberOfAudience)
    }
    
    private func calculate(_ numberOfAudience: Int) -> Money {
        return movie.calculateMovieFee(screening: self).times(percent: Double(numberOfAudience))
    }
}

public class Money {
    
    public static var zero = Money.wons(amount: 0)
    
    private var amount: Double
    
    public init(amount: Double) {
        self.amount = amount
    }
    
    public static func wons(amount: Double) -> Money {
        return Money(amount: amount)
    }
    
    public func plus(money: Money) -> Money {
        return Money(amount: self.amount + money.amount)
    }
    
    public func minus(money: Money) -> Money {
        return Money(amount: self.amount - money.amount)
    }
    
    public func times(percent: Double) -> Money {
        return Money(amount: self.amount * percent)
    }
    
    public func isLessThan(other: Money) -> Bool {
        return self.amount < other.amount
    }
    
    public func isGreaterThanOrEqual(other: Money) -> Bool {
        return self.amount >= other.amount
    }
}

public class Reservation {
    
    private let customer: Customer
    private let screening: Screening
    private let fee: Money
    private let numberOfAudience: Int
    
    public init(customer: Customer, screening: Screening, fee: Money, numberOfAudience: Int) {
        self.customer = customer
        self.screening = screening
        self.fee = fee
        self.numberOfAudience = numberOfAudience
    }
}

public class Movie {
    
    private let title: String
    private let runningTime: Double
    private let fee: Money
    private let discountPolicy: DiscountPolicy
    
    public init(title: String, runningTime: Double, fee: Money, discountPolicy: DiscountPolicy) {
        self.title = title
        self.runningTime = runningTime
        self.fee = fee
        self.discountPolicy = discountPolicy
    }
    
    public func getFee() -> Money {
        return fee
    }
    
    public func calculateMovieFee(screening: Screening) -> Money {
        return fee.minus(money: discountPolicy.calculateDiscountAmount(screening: screening))
    }
}

public protocol DiscountPolicy {
    
    var conditions: [DiscountCondition] { get }
    
    func calculateDiscountAmount(screening: Screening) -> Money
    func getDiscountAmount(screening: Screening) -> Money
}

public extension DiscountPolicy {
    
    func calculateDiscountAmount(screening: Screening) -> Money {
        for condition in conditions {
            if condition.isSatisfied(by: screening) {
                return getDiscountAmount(screening: screening)
            }
        }
        return .zero
    }
}

public class AmountDiscountPolicy: DiscountPolicy {
    
    public var conditions: [DiscountCondition] = []
    private let discountAmount: Money
    
    init(discountAmount: Money) {
        self.discountAmount = discountAmount
    }
    
    public func getDiscountAmount(screening: Screening) -> Money {
        return discountAmount
    }
}

public class PercentDiscountPolicy: DiscountPolicy {
    
    public var conditions: [DiscountCondition] = []
    private let percent: Double
    
    init(percent: Double) {
        self.percent = percent
    }
    
    public func getDiscountAmount(screening: Screening) -> Money {
        return screening.movieFee.times(percent: percent)
    }
}

public class NoneDiscountPolicy: DiscountPolicy {

    public var conditions: [DiscountCondition] = []
    
    public func getDiscountAmount(screening: Screening) -> Money {
        return .zero
    }
}

public protocol DiscountCondition {
    
    func isSatisfied(by screening: Screening) -> Bool
}

public class SequenceCondition: DiscountCondition {
    
    private let sequence: Int
    
    init(sequence: Int) {
        self.sequence = sequence
    }
    
    public func isSatisfied(by screening: Screening) -> Bool {
        return screening.isSequence(sequence)
    }
}

public class PeriodCondition: DiscountCondition {
    
    private let dayOfWeek: Date
    private let startTime: Date
    private let endTime: Date
    
    init(dayOfWeek: Date, startTime: Date, endTime: Date) {
        self.dayOfWeek = dayOfWeek
        self.startTime = startTime
        self.endTime = endTime
    }
    
    public func isSatisfied(by screening: Screening) -> Bool {
        // 이부분에 날짜비교는 생략한다.
        return true
    }
}


