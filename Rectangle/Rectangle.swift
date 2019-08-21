//
//  Rectangle.swift
//  Rectangle
//
//  Created by Ben on 2019/08/21.
//  Copyright © 2019 Ben. All rights reserved.
//

import Foundation

struct Rectangle {
    
    var left: Int
    var top: Int
    var right: Int
    var bottom: Int
    
    func getLeft() -> Int {
        return left
    }
    
    mutating func setLeft(_ left: Int) {
        self.left = left
    }
    
    func getTop() -> Int {
        return top
    }
    
    mutating func setTop(_ top: Int) {
        self.top = top
    }
    
    func getRight() -> Int {
        return right
    }
    
    mutating func setRight(_ right: Int) {
        self.right = right
    }
    
    func getBottom() -> Int {
        return bottom
    }
    
    mutating func setBottom(_ bottom: Int) {
        self.bottom = bottom
    }
}

class AnyClass {
    
    func anyFunction(rectangle: Rectangle, multiple: Int) -> Rectangle {
        var rectangle = rectangle
        rectangle.setRight(rectangle.getRight() * multiple)
        rectangle.setBottom(rectangle.getBottom() * multiple)
        return rectangle
    }
}

/*
 위 코드의 문제점
 - 중복 코드가 발생할 확률이 높다.
    - 아마도 다른 곳에서 사각형의 너비와 높이를 증가하는 코드가 필요하다면 유사 코드가 중복 될 것이다.
 - 변경에 취약하다.
    - 만약 right, bottom대신 length와 height를 이용한다면 수정해야할 곳이 엄청 많아진다.
 
 아래 코드에서 해결해보자.
 */
