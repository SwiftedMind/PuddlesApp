//
//  Copyright © 2023 Dennis Müller and all collaborators
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import IdentifiedCollections

public struct Thread: Identifiable, Hashable, Sendable, Codable {
    public var id: UUID = .init()
    public var title: String
    public var items: IdentifiedArrayOf<Item> = []
}

extension Thread {

    public struct Item: Identifiable, Hashable, Sendable, Codable {
        public var id: UUID = .init()
        public var type: ItemType

        public var remarks: IdentifiedArrayOf<ItemRemark> = []
        public var comments: IdentifiedArrayOf<ItemComment> = []
    }
    
    public enum ItemType: Hashable, Sendable, Codable {
        case fact(String)
        case labeledImage(URL, String)
    }

    public struct ItemRemark: Identifiable, Hashable, Sendable, Codable {
        public var id: UUID = .init()
        public var content: String
    }

    public struct ItemComment: Identifiable, Hashable, Sendable, Codable {
        public var id: UUID = .init()
        public var content: String
    }

    public struct ItemView {}
}

extension Thread {

    public static var draft: Thread {
        .init(title: "")
    }

    public static var mock: Thread {
        .init(
            title: "A Few Interesting Things About Our Solar System",
            items: [
                .mockLabeledImage,
                .init(
                    type: .fact("The sun is a nearly perfect spherical shape, and accounts for 92.27% of the total mass of the entire solar system."),
                    remarks: [
                        .init(content: "Actually, it's 99.86% of the total mass.")
                    ]
                ),
                .init(type: .fact("The asteroid belt between Mars and Jupiter is home to hundreds of thousands of asteroids, but is still largely empty space.")),
                .init(type: .fact("Neptune has the strongest winds of any planet in the solar system, reaching speeds of up to 2,100 kilometers per hour.")),
                .init(type: .fact("Venus is the only planet in the solar system to rotate in a clockwise direction.")),
                .init(
                    type: .fact("The largest volcano in the solar system, Olympus Mons, is located on Mars and is three times taller than Mount Everest."),
                    comments: [
                        .init(content: "This is so cool!")
                    ]
                ),
                .init(type: .fact("The average surface temperature on Mercury is 800 degrees Fahrenheit, making it the hottest planet in the solar system.")),
                .init(type: .fact("Saturn's moon, Titan, is the only moon in the solar system with a dense atmosphere.")),
                .init(type: .fact("Uranus rotates on its side, meaning that its poles are located where most planets have their equators.")),
                .init(type: .fact("The Kuiper Belt is a region beyond Neptune that is home to thousands of icy objects, including dwarf planets like Pluto.")),
                .init(type: .fact("Jupiter's moon, Io, has over 400 active volcanoes, making it the most geologically active object in the solar system.")),
            ]
        )
    }

    public static var random: Thread {
        .init(title: faker.zelda.game(), items: .repeating(.random, count: 10))
    }

}

extension Thread.Item {

    public static var mockFact: Thread.Item {
        .init(type: .fact("The sun is a nearly perfect spherical shape, and accounts for 99.86% of the total mass of the entire solar system."))
    }

    public static var mockLabeledImage: Thread.Item {
        .init(type: .labeledImage(.mock, "Something"))
    }

    public static var random: Thread.Item {
        .init(type: .fact(faker.lorem.sentence()))
    }

}
