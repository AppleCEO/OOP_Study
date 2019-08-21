//
//  Movie.swift
//  Movie_Data
//
//  Created by Ben on 2019/08/15.
//  Copyright © 2019 Ben. All rights reserved.
//

import Foundation

public class Money {
    
    public static var zero = Money.wons(amount: 0)
    
    private var amount: Double
    
    public init(amount: Double = 0.0) {
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
    
    public func times(value: Int) -> Money {
        return Money(amount: self.amount * Double(value))
    }
    
    public func isLessThan(other: Money) -> Bool {
        return self.amount < other.amount
    }
    
    public func isGreaterThanOrEqual(other: Money) -> Bool {
        return self.amount >= other.amount
    }
}

class Movie {
    
    enum MovieType {
        case amountDiscount
        case percentDiscount
        case none
    }
    
    private var title: String = ""
    private var runningTime: Double = 0.0
    private var fee: Money = Money()
    private var discountConditions: [DiscountCondition] = []
    private(set) var movieType: MovieType = . none
    private var discountAmount: Money = Money()
    private var discountPercent: Double = 0.0
    
    func calculateAmountDiscountedFee() -> Money {
        switch movieType {
        case .amountDiscount:
            return fee.minus(money: discountAmount)
        case .percentDiscount, .none:
            return fee
        }
    }
    
    func calculatePercentDiscountedFee() -> Money {
        switch movieType {
        case .percentDiscount:
            return fee.minus(money: fee.times(percent: discountPercent))
        case .amountDiscount, .none:
            return fee
        }
    }
    
    func calculatePercentNoneFee() -> Money {
        return fee
    }
    
    func isDiscountable(whenScreened: Date, sequence: Int) -> Bool {
        var isDiscountable: Bool = false
        discountConditions.forEach { condition in
            switch condition.type {
            case .period where condition.isDiscountable(dayOfWeek: whenScreened, time: whenScreened):
                isDiscountable = true
            case .sequence where condition.isDiscountable(sequence: sequence):
                isDiscountable = true
            default:
                isDiscountable = false
            }
        }
        return isDiscountable
    }
}

class DiscountCondition {
    
    enum DiscountConditionType {
        case sequence
        case period
    }
    
    private(set) var type: DiscountConditionType = .sequence
    private var sequence: Int = 0
    private var dayOfWeek: Date = Date()
    private var startTime: Date = Date()
    private var endTime: Date = Date()
    
    func isDiscountable(dayOfWeek: Date, time: Date) -> Bool {
        switch type {
        case .period: return false
        case .sequence: return true // 날짜 비교 로직은 제외함.
        }
    }
    
    func isDiscountable(sequence: Int) -> Bool {
        switch type {
        case .period: return false
        case .sequence: return self.sequence == sequence
        }
    }
}

class Screening {
    
    private var movie: Movie = Movie()
    private var sequence: Int = 0
    private var whenScreened: Date = Date()
    
    func calculateFee(audienceCount: Int) -> Money {
        switch movie.movieType {
        case .amountDiscount where movie.isDiscountable(whenScreened: whenScreened, sequence: sequence):
             return movie.calculateAmountDiscountedFee().times(value: audienceCount)
        case .percentDiscount where movie.isDiscountable(whenScreened: whenScreened, sequence: sequence):
            return movie.calculatePercentDiscountedFee().times(value: audienceCount)
        case .none:
            return movie.calculatePercentNoneFee().times(value: audienceCount)
        default:
            return movie.calculatePercentNoneFee().times(value: audienceCount)
        }
    }
}

class Reservation {
    
    var customer: Customer = Customer()
    var screening: Screening = Screening()
    var fee: Money = Money()
    var audienceCount: Int = 0
    
    init(customer: Customer, screening: Screening, fee: Money, audienceCount: Int) {
        self.customer = customer
        self.screening = screening
        self.fee = fee
        self.audienceCount = audienceCount
    }
}

class Customer {
    
    var name: String = ""
    var id: String = ""
    
    init(name: String = "", id: String = "") {
        self.name = name
        self.id = id
    }
}

class ReservationAgency {
    
    func reserve(screening: Screening, customer: Customer, audienceCount: Int) -> Reservation {
        let fee = screening.calculateFee(audienceCount: audienceCount)
        return Reservation(customer: customer, screening: screening, fee: fee, audienceCount: audienceCount)
    }
}
