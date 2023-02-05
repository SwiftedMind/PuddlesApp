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

import SwiftUI

extension Thread.ItemView {
    struct Fact: View {
        var content: String
        var remark: Thread.ItemRemark?
        var onRemark: () -> Void
        var onComment: () -> Void

        var body: some View {
            Text(content)
                .contextMenu {
                    Button {
                        onRemark()
                    } label: {
                        Label("Add Remark", systemImage: "info.square")
                    }
                    Button {
                        onComment()
                    } label: {
                        Label("Add Comment", systemImage: "bubble.left.and.bubble.right")
                    }
                }
            if let remark {
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundColor(.gray)
                    VStack(alignment: .leading) {
                        Text("People pointed out")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(remark.content)
                            .font(.callout)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

struct ThreadItemView_Fact_Previews: PreviewProvider {
    static var previews: some View {
        Thread.ItemView.Fact(content: "ABC", onRemark: {}, onComment: {})
    }
}
