//
//  Ticket.swift
//  Ticket
//
//  Created by Ben on 2019/07/28.
//  Copyright © 2019 Ben. All rights reserved.
//

import Foundation

public class Invitation {
    
    private let when: Date
    
    init(when: Date) {
        self.when = when
    }
}

public class Ticket {
    
    let fee: Double
    
    public init(fee: Double) {
        self.fee = fee
    }
}

public class Bag {
    
    private var amount: Double
    private let invitation: Invitation?
    private var ticket: Ticket?
    
    public var hasInvitation: Bool {
        return invitation != nil
    }
    
    public var hasTicket: Bool {
        return ticket != nil
    }
    
    public init(amount: Double) {
        self.amount = amount
        self.invitation = nil
        self.ticket = nil
    }
    
    public init(invitation: Invitation, amount: Double) {
        self.amount = amount
        self.invitation = invitation
        self.ticket = nil
    }
    
    public func setTicket(_ ticket: Ticket) {
        self.ticket = ticket
    }
    
    public func minusAmount(_ amount: Double) {
        self.amount -= amount
    }
    
    public func plusAmount(_ amount: Double) {
        self.amount += amount
    }
}

public class Audience {
    
    private let bag: Bag
    
    init(bag: Bag) {
        self.bag = bag
    }
    
    func buy(ticket: Ticket) -> Double {
        if bag.hasInvitation {
            bag.setTicket(ticket)
            return 0
        } else {
            bag.setTicket(ticket)
            bag.minusAmount(ticket.fee)
            return ticket.fee
        }
    }
}

public class TicketOffice {
    
    private var amount: Double
    private var tickets = [Ticket]()
    
    init(amount: Double, tickets: [Ticket]) {
        self.amount = amount
        self.tickets = tickets
    }

    public func getTicket() -> Ticket {
        return tickets.remove(at: 0)
    }
    
    public func minusAmount(_ amount: Double) {
        self.amount -= amount
    }
    
    public func plusAmount(_ amount: Double) {
        self.amount += amount
    }
}

public class TicketSeller {
    
    private let ticketOffice: TicketOffice
    
    public init(ticketOffice: TicketOffice) {
        self.ticketOffice = ticketOffice
    }
    
    public func sell(to audience: Audience) {
        ticketOffice.plusAmount(audience.buy(ticket: ticketOffice.getTicket()))
    }
}

public class Theater {
    
    private let ticketSeller: TicketSeller
    
    public init(ticketSeller: TicketSeller) {
        self.ticketSeller = ticketSeller
    }
    
    public func enter(audience: Audience) {
        ticketSeller.sell(to: audience)
    }
}
