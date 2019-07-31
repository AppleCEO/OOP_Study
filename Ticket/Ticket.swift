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
    
    private var hasInvitation: Bool {
        return invitation != nil
    }
    
    private var hasTicket: Bool {
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
    
    public func hold(_ ticket: Ticket) -> Double {
        if hasInvitation {
            setTicket(ticket)
            return 0
        } else {
            setTicket(ticket)
            minusAmount(ticket.fee)
            return ticket.fee
        }
    }
    
    private func setTicket(_ ticket: Ticket) {
        self.ticket = ticket
    }
    
    private func minusAmount(_ amount: Double) {
        self.amount -= amount
    }
    
    private func plusAmount(_ amount: Double) {
        self.amount += amount
    }
}

public class Audience {
    
    private let bag: Bag
    
    public init(bag: Bag) {
        self.bag = bag
    }
    
    public func buy(ticket: Ticket) -> Double {
        return bag.hold(ticket)
    }
}

public class TicketOffice {
    
    private var amount: Double
    private var tickets = [Ticket]()
    
    public init(amount: Double, tickets: [Ticket]) {
        self.amount = amount
        self.tickets = tickets
    }
    
    public func sellTicket(to audience: Audience) {
        plusAmount(audience.buy(ticket: getTicket()))
    }

    private func getTicket() -> Ticket {
        return tickets.remove(at: 0)
    }
    
    private func minusAmount(_ amount: Double) {
        self.amount -= amount
    }
    
    private func plusAmount(_ amount: Double) {
        self.amount += amount
    }
}

public class TicketSeller {
    
    private let ticketOffice: TicketOffice
    
    public init(ticketOffice: TicketOffice) {
        self.ticketOffice = ticketOffice
    }
    
    public func sell(to audience: Audience) {
        ticketOffice.sellTicket(to: audience)
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
