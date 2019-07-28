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
    
    init(fee: Double) {
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
    
    public var bag: Bag
    
    init(bag: Bag) {
        self.bag = bag
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
    
    var ticketOffice: TicketOffice
    
    init(ticketOffice: TicketOffice) {
        self.ticketOffice = ticketOffice
    }
}

public class Theater {
    
    private var ticketSeller: TicketSeller
    
    init(ticketSeller: TicketSeller) {
        self.ticketSeller = ticketSeller
    }
    
    public func enter(audience: Audience) {
        let ticket = ticketSeller.ticketOffice.getTicket()
        if !audience.bag.hasInvitation {
            audience.bag.minusAmount(ticket.fee)
            ticketSeller.ticketOffice.plusAmount(ticket.fee)
        }
        audience.bag.setTicket(ticket)
    }
}
