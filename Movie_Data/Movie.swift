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
    
    var title: String = ""
    var runningTime: Double = 0.0
    var fee: Money = Money()
    var discountConditions: [DiscountCondition] = []
    var movieType: MovieType = . none
    var discountAmount: Money = Money()
    var discountPercent: Double = 0.0
}

class DiscountCondition {
    
    enum DiscountConditionType {
        case sequence
        case period
    }
    
    var type: DiscountConditionType = .sequence
    var sequence: Int = 0
    var dayOfWeek: Date = Date()
    var startTime: Date = Date()
    var endTime: Date = Date()
}

class Screening {
    
    var movie: Movie = Movie()
    var sequence: Int = 0
    var whenScreened: Date = Date()
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
        let movie = screening.movie
        var discountable = false
        movie.discountConditions.forEach { condition in
            switch condition.type {
            case .period:
                discountable = true // 날짜 비교 로직은 생략함
            case .sequence:
                discountable = condition.sequence == screening.sequence
            }
        }
        
        let fee: Money
        if discountable {
            let discountAmount: Money
            switch movie.movieType {
            case .amountDiscount:
                discountAmount = movie.discountAmount
            case .percentDiscount:
                discountAmount = movie.fee.times(percent: movie.discountPercent)
            case .none:
                discountAmount = Money.zero
            }
            fee = movie.fee.minus(money: discountAmount).times(percent: Double(audienceCount))
        } else {
            fee = movie.fee
        }
        
        return Reservation(customer: customer, screening: screening, fee: fee, audienceCount: audienceCount)
    }
}
